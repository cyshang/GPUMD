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


/*----------------------------------------------------------------------------80
The driver class for the various integrators.
------------------------------------------------------------------------------*/


#include "integrate.cuh"

#include "atom.cuh"
#include "ensemble.cuh"
#include "ensemble_nve.cuh"
#include "ensemble_ber.cuh"
#include "ensemble_nhc.cuh"
#include "ensemble_lan.cuh"
#include "ensemble_bdp.cuh"
#include "force.cuh"


Integrate::Integrate(void)
{
    ensemble = NULL;
}


Integrate::~Integrate(void)
{
    // nothing
}


void Integrate::finalize(void)
{
    delete ensemble;
    ensemble = NULL;
}


void Integrate::initialize(Atom* atom)
{
    // determine the integrator
    switch (type)
    {
        case 0: // NVE
            ensemble = new Ensemble_NVE(type);
            break;
        case 1: // NVT-Berendsen
            ensemble = new Ensemble_BER
            (type, temperature, temperature_coupling);
            break;
        case 2: // NVT-NHC
            ensemble = new Ensemble_NHC            
            (
                type, atom->N, temperature, temperature_coupling, 
                atom->time_step
            );
            break;
        case 3: // NVT-Langevin
            ensemble = new Ensemble_LAN
            (type, atom->N, temperature, temperature_coupling);
            break;
        case 4: // NVT-BDP
            ensemble = new Ensemble_BDP            
            (type, temperature, temperature_coupling);
            break;
        case 11: // NPT-Berendsen
            ensemble = new Ensemble_BER
            (
                type, temperature, temperature_coupling, pressure_x, 
                pressure_y, pressure_z, pressure_coupling, deform_x,
                deform_y, deform_z, deform_rate
            );
            break;
        case 21: // heat-NHC
            ensemble = new Ensemble_NHC
            (
                type, source, sink, atom->group[0].cpu_size[source], 
                atom->group[0].cpu_size[sink], temperature,
                temperature_coupling, delta_temperature, atom->time_step
            );
            break;
        case 22: // heat-Langevin
            ensemble = new Ensemble_LAN
            (
                type, source, sink, 
                atom->group[0].cpu_size[source],
                atom->group[0].cpu_size[sink],
                atom->group[0].cpu_size_sum[source],
                atom->group[0].cpu_size_sum[sink],
                temperature, temperature_coupling, delta_temperature
            );
            break;
        case 23: // heat-BDP
            ensemble = new Ensemble_BDP
            (
                type, source, sink, temperature, temperature_coupling, 
                delta_temperature
            );
            break;
        default: 
            printf("Illegal integrator!\n");
            break;
    }
}


void Integrate::compute
(Atom *atom, Force *force, Measure* measure)
{
    ensemble->compute(atom, force, measure);
}


