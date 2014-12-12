% sensor_msgs_temperature_extract Converts a CSV file containing temperature data to a Matlab struct
%	sensor_msgs_fluid_pressure_extract(filename) filename is the name of the CSV file. Returns the
%		information in the CSV file as a Matlab struct

%   Copyright (c) 2014 David Anthony
%
%   This program is free software; you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation; either version 2 of the License, or
%   (at your option) any later version.
%
%   This program is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with this program; if not, write to the Free Software
%   Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

function [bag_data] = sensor_msgs_temperature_extract(filename)
fid = fopen(filename);
% Read the data in the file, according to the format specified in the first line of the file
C = textscan(...
	fid, ...
	'%s%n%n%n%n%n', ...
	'delimiter', ...
	',', ...
	'headerLines', ...
	1);
fclose(fid);
	
bag_data = struct(...
	'seq', C{2}, ...
	'nsecs', C{3}, ...
	'secs', C{4}, ...
	'times', C{4} + (C{3} / 1e9), ...
	'temperature', C{5}, ...
	'variance', C{6});
end
