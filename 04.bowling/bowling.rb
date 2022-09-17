#!/usr/bin/env ruby

# 引数を受け、"X"は"10,0"に置き換えてsplitで数字ごとに分けて整数化
score = ARGV[0].gsub("X", "10,0").split(",").map(&:to_i)

# 配列の中のスコアを2つずつにわける（10フレーム3投目はあまりの配列とした）
scores = []
score.each_slice(2) { |s| scores << s }

# フレームごとにわけた配列に番号をつけてハッシュ化
hash = Hash.new; scores.each.with_index(1) { |s, i| hash.store(i, s) }

# 得点の計算
total = 0

hash.each do |key, value|
  case
  when value == [10, 0] && key <= 9 && hash.fetch(key + 1) == [10, 0] # 9フレームまでに連続ストライクした場合
    total += value.sum + hash.fetch(key + 1)[0] + hash.fetch(key + 2)[0]
  when value == [10, 0] && key <= 9 # ストライクの場合
    total += value.sum + hash.fetch(key + 1).sum
  when value.sum == 10 && key <= 9 # スペアの場合
    total += value.sum + hash.fetch(key + 1)[0]
  else
    total += value.sum
  end
end

p total
