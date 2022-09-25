#!/usr/bin/env ruby
# frozen_string_literal: true

# 引数を受け、"X"は"10,0"に置き換えてsplitで数字ごとに分けて整数化
score = ARGV[0].gsub('X', '10,0').split(',').map(&:to_i)

# 配列の中のスコアを2つずつにわける（10フレーム3投目はあまりの配列とした）
scores = score.each_slice(2).to_a

# フレームごとにわけた配列に番号をつけてハッシュ化
flame_score = {}
scores.each.with_index(1) { |s, i| flame_score.store(i, s) }

# 得点の計算
total = 0

flame_score.each do |key, value|
  total +=
    if value == [10, 0] && key <= 9 && flame_score.fetch(key + 1) == [10, 0] # 9フレームまでに連続ストライクした場合
      value.sum + flame_score.fetch(key + 1)[0] + flame_score.fetch(key + 2)[0]
    elsif value == [10, 0] && key <= 9 # ストライクの場合
      value.sum + flame_score.fetch(key + 1).sum
    elsif value.sum == 10 && key <= 9 # スペアの場合
      value.sum + flame_score.fetch(key + 1)[0]
    else
      value.sum
    end
end

p total
