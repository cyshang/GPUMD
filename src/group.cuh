/*
    Copyright 2017 Zheyong Fan, Ville Vierimaa, Mikko Ervasti, and Ari Harju
    This file is part of GPUMD.
    GPUMD is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    GPUMD is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    You should have received a copy of the GNU General Public License
    along with GPUMD.  If not, see <http://www.gnu.org/licenses/>.
*/


#pragma once


struct Group
{
    int number;             // number of groups
    // GPU data
    int *label;             // atom label
    int *size;              // # atoms in each group
    int *size_sum;          // # atoms in all previous groups
    int *contents;          // atom indices sorted based on groups
    // CPU data corresponding to the above GPU data
    int* cpu_label;
    int* cpu_size;
    int* cpu_size_sum;
    int* cpu_contents;
};


