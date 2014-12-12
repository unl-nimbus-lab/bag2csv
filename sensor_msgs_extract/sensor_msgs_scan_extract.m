% sensor_msgs_scan_extract Converts a CSV file containing laser scan data to a Matlab struct
%	sensor_msgs_scan_extract(filename) filename is the name of the CSV file. Returns the information
%	in the CSV file as a Matlab struct

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

function [bag_data] = sensor_msgs_scan_extract(filename)
	fid = fopen(filename);
	% Format of first line with the column names
	C = textscan(...
		fid, ...
		'%n%n%n%s%n%n%n%s%n%n%s%n%n', ...
		'delimiter', ...
		',', ...
		'headerLines', ...
		1);
	fclose(fid);
	angle_increment = C{1}(1);
	angle_max = C{2}(1);
	angle_min = C{3}(1);
	range_max = C{9}(1);
	range_min = C{10}(1);
	nsecs = C{6};
	secs = C{7};
	times = secs + (nsecs / 1e9);
	ranges = C{11};
	ranges = rosArrayToCell(ranges);
	bag_data = struct('nsecs', nsecs, 'secs', secs, 'times', times, ...
		'ranges', ranges, 'angle_increment', angle_increment, ...
		'angle_max', angle_max, 'angle_min', angle_min, 'range_max', ...
		range_max, 'range_min', range_min);
end