#!/usr/bin/env ruby
require 'terminfo'

class AsciiArt
  def initialize art_file, padding=0
    @lines = File.open(art_file).read.split("\n").map {|x| (' '*padding)+x}
  end

  def [] start, length
    @lines.map{|x| x[start, length] or ''}
  end

  def length
    @lines.map{|x| x.length}.max
  end
end

class AsciiAnimation
  def initialize ascii_art
    @ascii_art = ascii_art
  end

  def play frame_delay=0.1
    (0..@ascii_art.length).each do |shift|
      show_frame shift
      sleep frame_delay
    end
    clear
  end

  def show_frame shift
    term_lines, term_columns = TermInfo.screen_size
    lines = @ascii_art[shift, term_columns].last term_lines
    clear
    lines.each {|line| puts line}
  end

  def clear
    print "\e[H\e[2J"
  end
end

_, term_columns = TermInfo.screen_size
art = AsciiArt.new File.join(__dir__,'art.txt'), term_columns
animation = AsciiAnimation.new art
begin
  animation.play 0.1
rescue SystemExit, Interrupt
  animation.clear
end