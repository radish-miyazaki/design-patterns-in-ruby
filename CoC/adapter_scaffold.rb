protocol_name = ARGV[0]
class_name = protocol_name.capitalize + 'Adapter'
file_name = File.join('adapter', protocol_name + '.rb')

scaffolding = %Q{
class #{class_name}
  def send_message(message)
    # メッセージを送信するコードを
  end
end
}

File.open(file_name, 'w') { |f| f.write(scaffolding) }
