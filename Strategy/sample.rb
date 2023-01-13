require 'forwardable'

class Report
  extend Forwardable
  attr_reader :title, :text
  attr_accessor :formatter

  def_delegator :@formatter, :output_report

  def initialize(formatter)
    @title = '月次報告'
    @text = %w[順調 最高]
    @formatter = formatter
  end

  def output_report
    @formatter.output_report(@title, @text)
  end
end

class HTMLFormatter
  def output_report(title, text)
    puts '<html>'
    puts '<head>'
    puts "<title>#{title}</title>"
    puts '</head>'
    puts '<body>'
    text.each { |line| puts "<p>#{line}</p>" }
    puts '</body>'
    puts '</html>'
  end
end

class PlainTextFormatter
  def output_report(title, text)
    puts "***** #{title} *****"
    text.each { |line| puts line }
  end
end

# client code
report = Report.new(HTMLFormatter.new)
report.output_report
