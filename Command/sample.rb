class SlickButton
  attr_accessor :command

  def initialize(&block)
    @command = block
  end

  def on_button_push
    @command.call if @command
  end
end

class SaveCommand
  def execute
    # 現在の文書を保存する処理
  end
end
