import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'todo_input_page.dart';
import 'todo_list_store.dart';
import 'todo.dart';

/// Todoリスト画面のクラス
///
/// 以下の責務を持つ
/// ・Todoリスト画面の状態を生成する
class TodoListPage extends StatefulWidget {
  /// コンストラクタ
  const TodoListPage({Key? key}) : super(key: key);

  /// Todoリスト画面の状態を生成する
  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

/// Todoリスト画面の状態クラス
///
/// 以下の責務を持つ
/// ・Todoリストを表示する
/// ・Todoの追加/編集画面へ遷移する
class _TodoListPageState extends State<TodoListPage> {
  /// ストア
  final TodoListStore _store = TodoListStore();

  /// Todoリスト入力画面に遷移する
  void _pushTodoInputPage([Todo? todo]) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return TodoInputPage(todo: todo);
        },
      ),
    );

    // Todoの追加/更新を行う場合があるため、画面を更新する
    setState(() {});
  }

  /// 初期処理を行う
  @override
  void initState() {
    super.initState();

    Future(
      () async {
        // ストアからTodoリストデータをロードし、画面を更新する
        setState(() => _store.load());
      },
    );
  }

  /// 画面を作成する
  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      appBar: AppBar(
        // アプリケーションバーに表示するタイトル
        title: const Text('Good & New リスト'),
      ),
      body: ListView.builder(
        // Todoの件数をリストの件数とする
        itemCount: _store.count(),
        itemBuilder: (context, index) {
          // インデックスに対応するTodoを取得する
          var item = _store.findByIndex(index);
          return Slidable(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                width: double.infinity,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(208, 208, 208, 100),
                      spreadRadius: 5,
                      blurRadius: 15,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: RawMaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onPressed: () {
                    // Todo編集画面に遷移する
                    _pushTodoInputPage(item);
                  },
                  child: ListTile(
                    // タイトル
                    title: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Text(
                            item.createDate,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            item.title,
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      // Todo追加画面に遷移するボタン
      floatingActionButton: FloatingActionButton(
        // Todo追加画面に遷移する
        onPressed: _pushTodoInputPage,
        // onPressed: () {
        //   _pushTodoInputPage(_store.findByIndex(_store.count()));
        // },
        child: const Icon(Icons.add),
      ),
    );
  }
}
