extends RefCounted
class_name BulletBehavior

## Bulletの動作を定義する基底クラス

## 状態
enum State {
	## 未定義
	UNDEFINED = 0,
	
	## 初期化直後
	INITIALIZED,
	
	## 動作中
	RUNNING,
	
	## 動作終了済み
	FINISHED,
	
	## エラー発生
	ERROR,
}

## 操作対象 Bullet インスタンス
var bullet : Bullet
## 現在の状態
var state : State = State.UNDEFINED

## 初期化処理
## b : 操作対象Bullet
func _init(b : Bullet):
	bullet = b
	state = State.INITIALIZED

## １ステップ動作する physics_processから呼び出される
## 派生クラスでオーバーライドして動作を定義する
func step(_delta) -> void:
	pass

func is_valid() -> bool:
	match state:
		State.INITIALIZED: return true
		State.RUNNING: return true
		_ : return false
