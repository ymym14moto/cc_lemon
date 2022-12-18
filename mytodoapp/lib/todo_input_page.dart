import 'package:flutter/material.dart';
import 'todo_list_store.dart';
import 'todo.dart';

/// Todo入力画面のクラス
///
/// 以下の責務を持つ
/// ・Todo入力画面の状態を生成する
class TodoInputPage extends StatefulWidget {
  /// Todoのモデル
  final Todo? todo;

  /// コンストラクタ
  /// Todoを引数で受け取った場合は更新、受け取らない場合は追加画面となる
  const TodoInputPage({Key? key, this.todo}) : super(key: key);

  /// Todo入力画面の状態を生成する
  @override
  State<TodoInputPage> createState() => _TodoInputPageState();
}

/// Todo入力ト画面の状態クラス
///
/// 以下の責務を持つ
/// ・Todoを追加/更新する
/// ・Todoリスト画面へ戻る
class _TodoInputPageState extends State<TodoInputPage> {
  /// ストア
  final TodoListStore _store = TodoListStore();

  /// 新規追加か
  late bool _isCreateTodo;

  /// 画面項目：タイトル
  late String _title;

  /// 画面項目：詳細
  late String _detail;

  /// 画面項目：完了か
  late bool _done;

  /// 画面項目：作成日時
  late String _createDate;

  /// 画面項目：更新日時
  late String _updateDate;

  /// 初期処理を行う
  @override
  void initState() {
    super.initState();
    var todo = widget.todo;

    _title = todo?.title ?? "";
    _detail = todo?.detail ?? "";
    _done = todo?.done ?? false;
    _createDate = todo?.createDate ?? "";
    _updateDate = todo?.updateDate ?? "";
    _isCreateTodo = todo == null;
  }

  /// 画面を作成する
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // アプリケーションバーに表示するタイトル
        title: Text(_isCreateTodo ? 'Good & New 追加' : 'Good & New 更新'),
      ),
      body: Container(
        // 全体のパディング
        padding: const EdgeInsets.all(30),
        child: Column(
          children: <Widget>[
            if ((widget.todo?.id ?? 0 - 1) > 1) ...[
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green)),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '<前回のGood & New>',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Text(
                          'Title: ${_store.findByIndex((widget.todo?.id ?? 1) - 2).title}'),
                      Text(
                          'Detail: ${_store.findByIndex((widget.todo?.id ?? 1) - 2).detail}'),
                    ],
                  ),
                ),
              ),
            ],
            if ((widget.todo?.id ?? 0 - 1) == -1) ...[
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green)),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '<前回のGood & New>',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Text(
                          'Title: ${_store.findByIndex(_store.count() - 1).title}'),
                      Text(
                          'Detail: ${_store.findByIndex(_store.count() - 1).detail}'),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            // タイトルのテキストフィールド
            TextField(
              autofocus: true,
              decoration: const InputDecoration(
                labelText: "タイトル",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
              ),
              // TextEditingControllerを使用することで、いちいちsetStateしなくても画面を更新してくれる
              controller: TextEditingController(text: _title),
              onChanged: (String value) {
                _title = value;
              },
            ),
            const SizedBox(height: 20),
            // 詳細のテキストフィールド
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: 3,
              decoration: const InputDecoration(
                labelText: "詳細",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
              ),
              // TextEditingControllerを使用することで、いちいちsetStateしなくても画面を更新してくれる
              controller: TextEditingController(text: _detail),
              onChanged: (String value) {
                _detail = value;
              },
            ),
            const SizedBox(height: 20),
            // 追加/更新ボタン
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_isCreateTodo) {
                    // Todoを追加する
                    _store.add(_done, _title, _detail);
                  } else {
                    // Todoを更新する
                    _store.update(widget.todo!, _done, _title, _detail);
                  }
                  // Todoリスト画面に戻る
                  Navigator.of(context).pop();
                },
                child: Text(
                  _isCreateTodo ? '追加' : '更新',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // キャンセルボタン
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Todoリスト画面に戻る
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  side: const BorderSide(
                    color: Colors.blue,
                  ),
                ),
                child: const Text(
                  "キャンセル",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // 作成日時のテキストラベル
            Text("作成日時 : $_createDate"),
            // 更新日時のテキストラベル
            Text("更新日時 : $_updateDate"),
          ],
        ),
      ),
    );
  }
}
