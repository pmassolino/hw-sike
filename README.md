# HW-SIKE

This repository has an FPGA implementation of the NIST Round 2 proposal SIKE :

+ David Jao, Reza Azarderakhsh, Matthew Campagna, Craig Costello, Luca De Feo, Basil Hess, Amir Jalali, Brian Koziel, Brian LaMacchia, Patrick Longa, Michael Naehrig, Joost Renes, Vladimir Soukharev, David Urbanik, Geovandro Pereira. [Supersingular Isogeny Key Encapsulation](https://sike.org/files/SIDH-spec.pdf). April 17, 2019. Post-Quantum Cryptography - NIST Round 2 submission.

The design was made in hardware/software co-design. The main CPU was made exclusively for this design, together with the multiplier accumulator co-processor called Carmela. There are two Carmela versions, one with a 128 bits multiplier and another with a 256 bits multiplier. Because there are two Carmela versions, there are two versions of the system, sike_core_v256 and sike_core_v128.

More information in the paper:

+ Pedro Maat C. Massolino, Patrick Longa, Joost Renes, and Lejla Batina. [A Compact and Scalable Hardware/Software Co-design of SIKE](https://github.com/pmassolino/hw-sike). 2020.

All the code that was created for this design is in public domain.
There are codes that have been used in this project, that have a different license, such as the ones in Xilinx project folders and the Keccak code.

All the Keccak VHDL code was obtained from:

+ Guido Bertoni, Joan Daemen, Michaël Peeters, and Gilles Van Assche. [Keccak in VHDL](https://keccak.team/hardware.html). 2012. https://keccak.team/hardware.html

And the SHA3/Keccak Python code was obtained from:

+ G. Bertoni, J. Daemen, M. Peeters, G. Van Assche, and R. Van Keer, [Keccak code package](https://github.com/XKCP/XKCP). June 2016, https://github.com/XKCP/XKCP

#### GHDL remarks

If you are going to use the GHDL to simulate this project, you have to change the file synth_double_ram.vhd
In the file there are two architectures : behavioral and vivado_behavioral. When performing GHDL simulations you have comment "vivado_behavioral" and use the "behavioral", and when you use Vivado or ISE to synthesize, you use the "vivado_behavioral".