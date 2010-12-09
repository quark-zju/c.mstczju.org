# coding: utf-8

module SubmissionsHelper
  def judge_results
    ['尚未评测', '正在评测', '编译错误', '答案正确', '格式错误', # 0 - 4
     '答案错误', '运行超时', '内存超限', '输出超限', '段错误',   # 5 - 9
     '运行出错', '内部错误', '非比赛时间']
  end

  def judge_accepted?(stat)
    stat == 3
  end

  def judge_rejected?(stat)
    not (stat <= 1 or stat >= 11 or stat == 3)
  end
end
