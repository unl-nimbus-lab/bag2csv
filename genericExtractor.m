% genericExtractor Generic conversion from CSV file generated by bag2csv.py to Matlab data.
%	Usage: genericExtractor(filename) returns a table representing the CSV data in filename

%   Copyright (c) 2015 David Anthony
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

function [T] = genericExtractor(filename)

% Read all the data in the csv file
T = readtable(filename);

% Go through the data we read in and handle special cases
for col_idx = 1:size(T, 2)
	col_name = T.Properties.VariableNames{col_idx};
	% Convert columns containing all 'True' and 'False' to logical values
	if(iscell(eval(strcat('T.', col_name))) && ...
		all(eval(strcat('strcmp(T.', col_name, ', ''True'')')) | ...
		eval(strcat('strcmp(T.', col_name, ', ''False'')'))))
		eval(strcat('T.', col_name, ' = strcmp(T.', col_name, ', ''True'');'));
	% Convert columns containing strings representing ROS arrays to Matlab arrays	
	elseif(iscell(eval(strcat('T.', col_name))) && ...
		all(cellfun(@ischar, eval(strcat('T.', col_name)))) && ...
		~all(cellfun(@isempty, regexp(eval(strcat('T.', col_name)), '[^_]+_[^_]+'))))
		eval(strcat('T.', col_name, ' = rosArrayToMatlabArray(', 'T.', col_name, ');'));
	end
end

% For convenience, messages with a standard header get their time field concatenated together
if(any(strcmp(T.Properties.VariableNames, 'header_stamp_nsecs')))
	T.header_times = (T.header_stamp_nsecs / 1e9) + T.header_stamp_secs;
end

end