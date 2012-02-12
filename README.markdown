Moving a robot from start to goal in between the walls of a maze
=================================================================

This is a small set of ruby scripts that solves the problem of moving a robot from start to goal, step-by-step, in between the walls
of a maze.

Try that out
============

On your command prompt, start and ```irb``` console and type in the following:

    ruby-1.9.3-p0 :008 > $: << "."
    ruby-1.9.3-p0 :009 > require "load"
    ruby-1.9.3-p0 :010 > width = 5
    ruby-1.9.3-p0 :011 > height = 4
    ruby-1.9.3-p0 :012 > walls = [Position.new(1, 3), Position.new(2, 3), Position.new(3, 3), Position.new(4, 3), Position.new(4, 2)]
    ruby-1.9.3-p0 :013 > maze = Maze.new(width, height, walls)
    ruby-1.9.3-p0 :014 > maze.start = 3, 2
    ruby-1.9.3-p0 :015 > maze.goal = 1, 4
    ruby-1.9.3-p0 :016 > maze.find_path_to_goal

Explanation:

* line: 008> put current path in load path
* line: 009> require just a script that loads all the necessary files
* line: 010> set local variable that will be used for the width of the maze
* line: 011> set local variable that will be used for the height of the maze
* line: 012> setting an ```Array``` of ```Position``` objects that define the positions in the maze that exist walls
* line: 013> instantiate the ```Maze```
* line: 014> set the starting position
* line: 015> set the goal position
* line: 016> The big one: This is the call to find the path from start to goal

Test It!
========

If you run

   rake

the tests will run.

Read more
=========

Visit the [Wiki pages](https://github.com/pmatsinopoulos/Maze-Algorithm/wiki) of the project, to read more about.





