require 'irb/completion'
require 'readline'

class Autocompleter
  def initialize
    @command = [
  "mkdir", "rmdir", "touch", "echo", "exit", "help", "grep", "sort", "uniq", "cat",
  "chmod", "chown", "move", "less", "tail", "head", "find", "history",
  "kill", "link", "more", "less", "tail", "head", "cpc", "cvc", "ben",
  "top", "tar", "gzip", "gunzip", "sed", "awk", "expr", "sleep", "wait",
  "which", "whereis", "whoami", "groups", "passwd", "sudo",
  "ssh", "scp", "ping", "wget", "curl", "ftp", "telnet", "date", "cal", "clear",
  "diff", "patch", "uname", "env", "export", "set", "unset", "source", "alias",
  "unalias", "ulimit", "jobs", "screen", "tmux", "time", "watch",
  "xargs", "yes", "zip", "unzip", "mount", "umount", "dd", "mkfs", "fdisk",
  "shutdown", "reboot", "logout"
]
  end

  def completion_proc(current_dir = '.')
    files = Dir.entries(current_dir).reject { |f| f == '.' || f == '..' }
    proc { |s| (@command + files).select {|input| input.start_with?(s) } }
  end
end
