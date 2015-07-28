class GameController < ApplicationController
  # This action is for the bare domain. You can ignore it.
  def home
    redirect_to("/mockup.html")
  end

  def rps
      @the_move = params["the_move"]

      @computer_move = ["rock", "paper", "scissors"].sample

      if @the_move == @computer_move
      @outcome = "tied"
    elsif @the_move == "paper" && @computer_move == "rock"
      @outcome = "won"
    elsif @the_move == "paper" && @computer_move == "scissors"
      @outcome = "lost"
    elsif @the_move == "scissors" && @computer_move == "rock"
      @outcome = "lost"
    elsif @the_move == "scissors" && @computer_move == "paper"
      @outcome = "won"
    elsif @the_move == "rock" && @computer_move == "paper"
      @outcome = "lost"
    elsif @the_move == "rock" && @computer_move == "scissors"
      @outcome = "won"
    end

    # Adding an entry to the Move table for this turn
    m = Move.new
    m.user_move = @the_move
    m.computer_move = @computer_move
    if @outcome == "won"
      m.user_wins = 1
      m.computer_wins = 0
      m.tie=0
    elsif @outcome == "lost"
      m.user_wins = 0
      m.computer_wins = 1
      m.tie=0
    else
      m.user_wins = 0
      m.computer_wins = 0
      m.tie=1
    end

    m.save

    @you_played_rock_and_won=Move.where({ :user_move => "rock", :user_wins => "1"}).count
    @you_played_rock_and_lost=Move.where({ :user_move => "rock", :computer_wins => "1"}).count
    @you_played_rock_and_tied=Move.where({ :user_move => "rock", :tie => "1"}).count

    @you_played_paper_and_won=Move.where({ :user_move => "paper", :user_wins => "1"}).count
    @you_played_paper_and_lost=Move.where({ :user_move => "paper", :computer_wins => "1"}).count
    @you_played_paper_and_tied=Move.where({ :user_move => "paper", :tie => "1"}).count

    @you_played_scissors_and_won=Move.where({ :user_move => "scissors", :user_wins => "1"}).count
    @you_played_scissors_and_lost=Move.where({ :user_move => "scissors", :computer_wins => "1"}).count
    @you_played_scissors_and_tied=Move.where({ :user_move => "scissors", :tie => "1"}).count

    @you_won=Move.where({ :user_wins => "1"}).count
    @you_lost=Move.where({ :computer_wins => "1"}).count
    @you_tied=Move.where({ :tie => "1"}).count

    @total_entries=Move.count

    @data = Move.all

    # http://stackoverflow.com/questions/29125692/dynamic-ajax-datatable-w-ruby-on-rails

    render("the_move.html.erb")
  end

end
