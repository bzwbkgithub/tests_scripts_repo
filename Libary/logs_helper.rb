require 'net/sftp'

LOG_FILE_PATH = '/sales_tty_offer_node1/bwappnode.log'
SOU_NODE_1 = {
  host: '10.151.102.155',
  username: 'srv_logs',
  password: 'srv_logs'
}

TEST_LOG_FILE = File.open("../../Logs/#{Time.now.strftime("%Y-%B-%dat%H;%M;%S")}.log", 'a')
def log *params
  # removing colors
  to_file = params.to_s.gsub('[32m', '').gsub('[0m', '').gsub('[31m', '').gsub('[33m', '').gsub('[34m', '').gsub('[35m', '').gsub('[36m', '').gsub('["', '').gsub('"]', '').gsub('\n', "\n").gsub('\e', '')
  TEST_LOG_FILE.puts to_file
  puts params
end

def count_lines(log_file_path)
  start = Time.now
  log "Counting log file: '#{log_file_path}' lines!"
  lines_count = 0
  log_file = nil
  Net::SFTP.start(SOU_NODE_1[:host], SOU_NODE_1[:username], :password => SOU_NODE_1[:password]) do |sftp|
    log_file = sftp.download!(LOG_FILE_PATH)
    lines_count = log_file.split("\n").count
  end
  log "Counting lines(#{lines_count}) execution Time: '#{Time.now - start}'"
  return lines_count, log_file
end
def read_lines(log_file_path, lines_to_show, log_file_string, msg = 'Success')
  lines = log_file_string.split("\n")
  lines.last(lines_to_show).each do |line|
    line = line.gsub(/(^20.+Log - )/, '').gsub('&amp;', '&').gsub('&lt;', '<')
    if msg == 'Success'
      doc = Document.new(line)
      doc.write(targetstr = "", 2) #indents with 2 spaces
      log "[LOG]: #{targetstr.gsub("\n", "\n[LOG]: ")}"
    else
      log "[LOG]: #{line}"
    end
  end
end
