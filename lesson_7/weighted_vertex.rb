# frozen_string_literal: true

class Station
  attr_accessor :name, :routes

  def initialize(name)
    @name = name
    @routes = {}
  end

  def add_route(station, time)
    @routes[station] = time
  end

  def shortest_path_to(destination)
    best_previous_stopovers = stopover_table_for(self)

    best_path = []

    current_station = destination.name

    while current_station != name
      best_path << current_station

      current_station = best_previous_stopovers[current_station]
    end

    best_path << name

    best_path.reverse
  end

  private

  def stopover_table_for(starting_station)
    fastest_table = {}
    unvisited_stations = []
    visited_stations = {}
    best_previous_stopovers = {}

    fastest_table[starting_station.name] = 0
    current_station = starting_station

    while current_station
      visited_stations[current_station.name] = true

      unvisited_stations.delete(current_station)

      current_station.routes.each do |adjacent_station, time|
        unvisited_stations << adjacent_station unless visited_stations[adjacent_station.name]

        time_through_current_station = fastest_table[current_station.name] + time

        next unless !fastest_table[adjacent_station.name] ||
                    time_through_current_station < fastest_table[adjacent_station.name]

        fastest_table[adjacent_station.name] = time_through_current_station
        best_previous_stopovers[adjacent_station.name] = current_station.name
      end

      current_station = unvisited_stations.min do |station, _|
        fastest_table[station.name]
      end
    end

    best_previous_stopovers
  end
end

a = Station.new('A')
b = Station.new('B')
c = Station.new('C')
d = Station.new('D')
e = Station.new('E')

a.add_route(b, 5)
a.add_route(d, 8)

b.add_route(a, 5)
b.add_route(c, 6)
b.add_route(d, 9)

c.add_route(e, 15)

d.add_route(c, 2)
d.add_route(e, 4)

puts a.shortest_path_to(c).inspect
