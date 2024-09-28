;buildInfoPackage: chisel3, version: 3.4.3, scalaVersion: 2.12.12, sbtVersion: 1.3.10
circuit Imem : 
  module Imem : 
    input clock : Clock
    input reset : UInt<1>
    output io : {flip data_in : UInt<32>, flip enable : UInt<1>, flip address : UInt<32>, out : UInt<32>}
    
    cmem memory : UInt<32>[256] @[Imem.scala 13:17]
    when io.enable : @[Imem.scala 18:20]
      node _T = shr(io.address, 2) @[Imem.scala 19:26]
      node _T_1 = bits(_T, 7, 0)
      write mport MPORT = memory[_T_1], clock
      MPORT <= io.data_in
      skip @[Imem.scala 18:20]
    node _io_out_T = shr(io.address, 2) @[Imem.scala 21:35]
    node _io_out_T_1 = bits(_io_out_T, 7, 0) @[Imem.scala 21:22]
    read mport io_out_MPORT = memory[_io_out_T_1], clock @[Imem.scala 21:22]
    io.out <= io_out_MPORT @[Imem.scala 21:8]
    
