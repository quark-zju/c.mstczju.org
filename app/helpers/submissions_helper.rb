# coding: utf-8

module SubmissionsHelper
  def judge_results
    ['尚未评测', '正在评测', '编译错误', '答案正确', '格式错误', '答案错误', '运行超时', '内存溢出', '段错误', '运行出错', '非法代码', '内部错误']
  end
end
