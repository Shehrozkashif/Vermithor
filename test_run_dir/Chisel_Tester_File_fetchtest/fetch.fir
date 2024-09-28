;buildInfoPackage: chisel3, version: 3.4.3, scalaVersion: 2.12.12, sbtVersion: 1.3.10
circuit fetch : 
  module pc : 
    input clock : Clock
    input reset : Reset
    output io : {flip imm : UInt<32>, out : UInt<32>, flip jump : UInt<1>}
    
    io.out <= UInt<1>("h00") @[pc.scala 19:10]
    reg pc : UInt<32>, clock with : (reset => (reset, UInt<32>("h00"))) @[pc.scala 21:19]
    when io.jump : @[pc.scala 23:14]
      pc <= io.imm @[pc.scala 24:4]
      skip @[pc.scala 23:14]
    else : @[pc.scala 26:11]
      node _pc_T = add(pc, UInt<3>("h04")) @[pc.scala 27:11]
      node _pc_T_1 = tail(_pc_T, 1) @[pc.scala 27:11]
      pc <= _pc_T_1 @[pc.scala 27:4]
      skip @[pc.scala 26:11]
    io.out <= pc @[pc.scala 30:8]
    
  module Imem : 
    input clock : Clock
    input reset : Reset
    output io : {flip address : UInt<32>, out : UInt<32>}
    
    cmem memory : UInt<32>[1024] @[Imem.scala 11:17]
    node _T = shr(io.address, 2) @[Imem.scala 17:26]
    node _T_1 = bits(_T, 9, 0)
    write mport MPORT = memory[_T_1], clock
    MPORT <= UInt<1>("h00")
    node _io_out_T = shr(io.address, 2) @[Imem.scala 19:35]
    node _io_out_T_1 = bits(_io_out_T, 9, 0) @[Imem.scala 19:22]
    read mport io_out_MPORT = memory[_io_out_T_1], clock @[Imem.scala 19:22]
    io.out <= io_out_MPORT @[Imem.scala 19:8]
    
  module fetch : 
    input clock : Clock
    input reset : UInt<1>
    output io : {pc_fetch_out : UInt<32>, Imem_fetch_out : UInt<32>, flip pc_imm_execute : UInt<32>}
    
    inst pcmod of pc @[fetch.scala 25:23]
    pcmod.clock <= clock
    pcmod.reset <= reset
    inst inmmod of Imem @[fetch.scala 26:24]
    inmmod.clock <= clock
    inmmod.reset <= reset
    inmmod.io.address <= pcmod.io.out @[fetch.scala 35:23]
    pcmod.io.imm <= io.pc_imm_execute @[fetch.scala 39:18]
    io.pc_fetch_out <= pcmod.io.out @[fetch.scala 44:21]
    io.Imem_fetch_out <= inmmod.io.out @[fetch.scala 48:23]
    node _T = bits(io.Imem_fetch_out, 6, 0) @[fetch.scala 50:27]
    node _T_1 = eq(_T, UInt<7>("h063")) @[fetch.scala 50:34]
    node _T_2 = bits(io.Imem_fetch_out, 6, 0) @[fetch.scala 50:63]
    node _T_3 = eq(_T_2, UInt<7>("h06f")) @[fetch.scala 50:69]
    node _T_4 = or(_T_1, _T_3) @[fetch.scala 50:43]
    when _T_4 : @[fetch.scala 50:82]
      pcmod.io.jump <= UInt<1>("h01") @[fetch.scala 51:23]
      skip @[fetch.scala 50:82]
    else : @[fetch.scala 53:15]
      pcmod.io.jump <= UInt<1>("h00") @[fetch.scala 54:21]
      skip @[fetch.scala 53:15]
    
