#!/usr/bin/env ruby
# frozen_string_literal: true

# カレントディレクトリの隠しフォルダ以外の取得するメソッド
def data_gets
  Dir.glob('*').sort
end

# 3で割って縦に何個表示するかを求め、後にtransposeで高さに変換する値をheightとするメソッド
def height
  # データの幅の指定(必要時変更)
  data_width = 3
  (data_gets.size / data_width) + 1
end

# 各要素で1番多い文字数を取得するメソッド
def string_count
  data_gets.map(&:length).max
end

def data_display
  # データ表示のバランスを左詰め空白を入れて調整
  # データを分割し2次元配列に（スライスする要素数は高さによって変わる）
  slice_data = data_gets.map { |d| d.ljust(string_count) }.each_slice(height).to_a
  # 要素数が揃っていない場合はnilで調整
  # transposeして表示する形に修正
  slice_data.map { |data| data.values_at(0...height) }.transpose.map { |display| display.join(' ') }
end

puts data_display
