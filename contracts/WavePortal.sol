// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.9;
// //コントラクトを実行する際、コンソールログをターミナルに出力するため
// //vscodeのsolidityの拡張機能のせい
// import "hardhat/console.sol";

// contract WavePortal {
//     uint256 totalWaves;
//     uint256 totalJanekens;
//     /* 乱数生成のための基盤となるシード（種）を作成 */
//     uint256 private seed;
//     /*
//      * NewWaveイベントの作成
//      */
//     event NewWave(address indexed from, uint256 timestamp, string message);
//     event NewJankeResult(address indexed from, uint256 timestamp, string message, string message);
//     /*
//      * Waveという構造体を作成。
//      * 構造体の中身は、カスタマイズすることができます。
//      */
//     struct Wave {
//         address waver; //「👋（wave）」を送ったユーザーのアドレス
//         string message; // ユーザーが送ったメッセージ
//         uint256 timestamp; // ユーザーが「👋（wave）」を送った瞬間のタイムスタンプ
//     }

//     struct Janken {
//         address player;
//         string hand;
//         uint timestamp;
//         string result;
//     }
//     /*
//      * 構造体の配列を格納するための変数wavesを宣言。
//      * これで、ユーザーが送ってきたすべての「👋（wave）」を保持することができます。
//      */
//     Wave[] waves;
//     Janken[] jankens;

//     /*
//      * "address => uint mapping"は、アドレスと数値を関連付ける
//      */
//     mapping(address => uint256) public lastWavedAt;
//     //アドレスと時間の辞書
//     mapping(address => uint256) public lastJankenAt;

//     // constructor(){
//     //     console.log("Here is my first smart contract!");
//     // }
//     //payable を加えることで、コントラクトに送金機能を実装
//     constructor() payable {
//         console.log("We have been constructed!");
//         /*
//          * 初期シードを設定
//          */
//         seed = (block.timestamp + block.difficulty) % 100;
//     }

//     function janken(string memory _hand) public {
//         //じゃんけんは30sに一回
//         require(
//             lastWavedAt[msg.sender] + 30 seconds < block.timestamp,
//             "Wait 30s"
//         );
//         //ユーザのタイムスタンプを更新
//         //これで次，前回のじゃんけんがいつだったかわかるようになる
//         lastWavedAt[msg.sender] = block.timestamp;
//         //誰がじゃんけんするか
//         console.log("%s plays janken!", msg.sender);
//         totalJanekens += 1;

//         //乱数生成
//         seed = (block.difficulty + block.timestamp + seed) % 100;
//         //勝ち，負け，あいこを当確率で出す
//         if (seed <= 33) {
//             console.log("%s won!", msg.sender);
//             string result = "win";
//             //結果を記録
//             jankens.push(Janken(msg.sender,_hand,block.timestamp,result));
//             /*
//              * ユーザーにETHを送るためのコードは以前と同じ
//              */
//             uint256 prizeAmount = 0.0001 ether;
//             //残高を見て遅れるかどうかを確認
//             //require の結果が false の場合（＝コントラクトが持つ資金が足りない場合）は、トランザクションをキャンセル
//             require(
//                 prizeAmount <= address(this).balance,
//                 "Trying to withdraw more money than the contract has."
//             );
//             //ユーザーに送金を行うために実装
//             (bool success, ) = (msg.sender).call{value: prizeAmount}("");
//             //トランザクション（＝送金）が成功したことを確認
//             require(success, "Failed to withdraw money from contract.");
//         } else if (33 < seed <= 66) {
//             console.log("%s ended in a tie.", msg.sender);
//             string result = "draw";
//             jankens.push(Janken(msg.sender,_hand,block.timestamp,result));
//         } else {
//             console.log("%s did not win.", msg.sender);
//             string result = "lose";
//             jankens.push(Janken(msg.sender,_hand,block.timestamp,result));
//         }

//         emit NewWave(msg.sender, _hand, block.timestamp,result);

//     }

//     /*
//      * _messageという文字列を要求するようにwave関数を更新。
//      * _messageは、ユーザーがフロントエンドから送信するメッセージです。
//      */
//     function wave(string memory _message) public {
//         /*
//          * 現在ユーザーがwaveを送信している時刻と、前回waveを送信した時刻が15分以上離れていることを確認。
//          */
//         require(
//             lastWavedAt[msg.sender] + 30 seconds < block.timestamp,
//             "Wait 30s"
//         );

//         /*
//          * ユーザーの現在のタイムスタンプを更新する
//          */
//         lastWavedAt[msg.sender] = block.timestamp;

//         totalWaves += 1;
//         console.log("%s has waved!", msg.sender);
//         /*
//          * 「👋（wave）」とメッセージを配列に格納。
//          */
//         waves.push(Wave(msg.sender, _message, block.timestamp));
//         /*
//          * ユーザーのために乱数を生成
//          */
//         seed = (block.difficulty + block.timestamp + seed) % 100;

//         console.log("Random # generated: %d", seed);
//         /*
//          * ユーザーがETHを獲得する確率を50％に設定
//          */
//         if (seed <= 50) {
//             console.log("%s won!", msg.sender);

//             /*
//              * ユーザーにETHを送るためのコードは以前と同じ
//              */
//             uint256 prizeAmount = 0.0001 ether;
//             //残高を見て遅れるかどうかを確認
//             //require の結果が false の場合（＝コントラクトが持つ資金が足りない場合）は、トランザクションをキャンセル
//             require(
//                 prizeAmount <= address(this).balance,
//                 "Trying to withdraw more money than the contract has."
//             );
//             //ユーザーに送金を行うために実装
//             (bool success, ) = (msg.sender).call{value: prizeAmount}("");
//             //トランザクション（＝送金）が成功したことを確認
//             require(success, "Failed to withdraw money from contract.");
//         } else {
//             console.log("%s did not win.", msg.sender);
//         }
//         /*
//          * コントラクト側でemitされたイベントに関する通知をフロントエンドで取得できるようにする。
//          */
//         emit NewWave(msg.sender, block.timestamp, _message);
//         /*
//          * 「👋（wave）」を送ってくれたユーザーに0.0001ETHを送る
//          */
//         // uint256 prizeAmount = 0.0001 ether;
//         // //コントラクトが持つ残高を下回っているか
//         // //require の結果が false の場合（＝コントラクトが持つ資金が足りない場合）は、トランザクションをキャンセル
//         // require(
//         //     prizeAmount <= address(this).balance,
//         //     "Trying to withdraw more money than the contract has."
//         // );
//         // //ユーザーに送金を行うために実装
//         // (bool success, ) = (msg.sender).call{value: prizeAmount}("");
//         // //トランザクション（＝送金）が成功したことを確認
//         // require(success, "Failed to withdraw money from contract.");
//     }

//     /*
//      * 構造体配列のwavesを返してくれるgetAllWavesという関数を追加。
//      * これで、私たちのWEBアプリからwavesを取得することができます。
//      */
//     function getAllWaves() public view returns (Wave[] memory) {
//         return waves;
//     }

//     function getTotalWaves() public view returns (uint256) {
//         console.log("We have %d total waves!", totalWaves);
//         return totalWaves;
//     }

//     function getAllJankens() public view returns (Janken[] memory) {
//         return jankens;
//     }

//     function getTotalJankens() public view returns (uint256) {
//         return totalJanekens;
//     }
// }
