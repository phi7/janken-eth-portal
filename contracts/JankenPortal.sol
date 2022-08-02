// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
//コントラクトを実行する際、コンソールログをターミナルに出力するため
//vscodeのsolidityの拡張機能のせい
import "hardhat/console.sol";

contract JankenPortal {
    uint256 totalJanekens;
    /* 乱数生成のための基盤となるシード（種）を作成 */
    uint256 private seed;
    string result;

    event NewJankeResult(address indexed from, string hand,uint256 timestamp, string result);

    struct Janken {
        address player;
        string hand;
        uint timestamp;
        string result;
    }
    /*
     * 構造体の配列を格納するための変数jankensを宣言。
     * これで、ユーザーが送ってきたすべての「janken」を保持することができます。
     */
    Janken[] jankens;

    /*
     * "address => uint mapping"は、アドレスと数値を関連付ける
     */
    //アドレスと時間の辞書
    mapping(address => uint256) public lastJankenAt;

    //payable を加えることで、コントラクトに送金機能を実装
    constructor() payable {
        console.log("We have been constructed!");
        /*
         * 初期シードを設定
         */
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function janken(string memory _hand) public {
        //じゃんけんは30sに一回
        require(
            lastJankenAt[msg.sender] + 30 seconds < block.timestamp,
            "Wait 30s"
        );
        //ユーザのタイムスタンプを更新
        //これで次，前回のじゃんけんがいつだったかわかるようになる
        lastJankenAt[msg.sender] = block.timestamp;
        //誰がじゃんけんするか
        console.log("%s plays janken!", msg.sender);
        totalJanekens += 1;

        //乱数生成
        seed = (block.difficulty + block.timestamp + seed) % 100;
        //勝ち，負け，あいこを当確率で出す
        if (seed <= 33) {
            console.log("%s won!", msg.sender);
            result = "win";
            //結果を記録
            jankens.push(Janken(msg.sender,_hand,block.timestamp,result));
            /*
             * ユーザーにETHを送るためのコードは以前と同じ
             */
            uint256 prizeAmount = 0.00001 ether;
            //残高を見て遅れるかどうかを確認
            //require の結果が false の場合（＝コントラクトが持つ資金が足りない場合）は、トランザクションをキャンセル
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            //ユーザーに送金を行うために実装
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            //トランザクション（＝送金）が成功したことを確認
            require(success, "Failed to withdraw money from contract.");
        } else if (33 < seed && seed <= 66) {
            console.log("%s ended in a tie.", msg.sender);
            result = "draw";
            jankens.push(Janken(msg.sender,_hand,block.timestamp,result));
        } else {
            console.log("%s did not win.", msg.sender);
            result = "lose";
            jankens.push(Janken(msg.sender,_hand,block.timestamp,result));
        }

        emit NewJankeResult(msg.sender, _hand, block.timestamp,result);

    }

    /*
     * 構造体配列のwavesを返してくれるgetAllJankensという関数を追加。
     * これで、私たちのWEBアプリからjankensを取得することができます。
     */

    function getAllJankens() public view returns (Janken[] memory) {
        return jankens;
    }

    function getTotalJankens() public view returns (uint256) {
        return totalJanekens;
    }
}
