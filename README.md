# Windows Update Cleaner

Windows Updateのキャッシュ掃除を行います。

## 推奨環境

* OS: Windows 11以降

## 動作確認環境

* OS: Windows 11 Pro

## 動作内容

1. 管理者権限のチェック
2. Windows Update関連のサービス停止
3. Windows Update関連のフォルダーとファイルを削除
4. Windows Update関連のサービス開始
5. Windows Updateのスキャンを実施

## 管理者権限について

このbatファイルの実行には、管理者権限が必要です。

このbatファイルは、管理者権限で実行されていない場合には、
自動的に新しいコマンドプロンプトを管理者権限で開いてbatを起動します。

## コマンドプロンプトの終了について

通常動作では、処理完了後にコマンドプロンプトを終了させます。

もし、コマンドプロンプトを終了させたくない場合には、
引数に「/b」を渡してください。

## Usage

```cmd
WindowsUpdateCleaner.bat      : batを実行します。終了後、コマンドプロンプトも終了させます。
WindowsUpdateCleaner.bat /b   : batを実行します。終了後、コマンドプロンプトを終了させません。
WindowsUpdateCleaner.bat /h   : ヘルプを表示します。
WindowsUpdateCleaner.bat --?  : ヘルプを表示します。
```
