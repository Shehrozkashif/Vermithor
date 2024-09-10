;buildInfoPackage: chisel3, version: 3.4.3, scalaVersion: 2.12.12, sbtVersion: 1.3.10
circuit fetch : 
  module pc : 
    input clock : Clock
    input reset : Reset
    output io : {flip imm : UInt<32>, out : UInt<32>, flip jump : UInt<1>, flip jump2 : UInt<1>, flip jump3 : UInt<1>}
    
    io.out <= UInt<1>("h00") @[pc.scala 18:10]
    reg pc : UInt<32>, clock with : (reset => (reset, UInt<32>("h00"))) @[pc.scala 20:19]
    when io.jump : @[pc.scala 22:14]
      pc <= io.imm @[pc.scala 23:4]
      skip @[pc.scala 22:14]
    else : @[pc.scala 25:11]
      node _pc_T = add(pc, UInt<3>("h04")) @[pc.scala 26:11]
      node _pc_T_1 = tail(_pc_T, 1) @[pc.scala 26:11]
      pc <= _pc_T_1 @[pc.scala 26:4]
      skip @[pc.scala 25:11]
    node _T = eq(pc, UInt<11>("h0400")) @[pc.scala 28:9]
    when _T : @[pc.scala 28:17]
      pc <= UInt<1>("h00") @[pc.scala 29:4]
      skip @[pc.scala 28:17]
    when io.jump2 : @[pc.scala 31:16]
      pc <= io.imm @[pc.scala 33:4]
      skip @[pc.scala 31:16]
    when io.jump3 : @[pc.scala 36:16]
      pc <= io.imm @[pc.scala 37:4]
      skip @[pc.scala 36:16]
    io.out <= pc @[pc.scala 40:8]
    
  module Imem : 
    input clock : Clock
    input reset : Reset
    output io : {flip enable : UInt<1>, flip address : UInt<32>, out : UInt<32>}
    
    cmem memory : UInt<32>[256] @[Imem.scala 15:19]
    node _io_out_T = shr(io.address, 2) @[Imem.scala 26:36]
    node _io_out_T_1 = bits(_io_out_T, 7, 0) @[Imem.scala 26:24]
    read mport io_out_MPORT = memory[_io_out_T_1], clock @[Imem.scala 26:24]
    io.out <= io_out_MPORT @[Imem.scala 26:10]
    
  module fetch : 
    input clock : Clock
    input reset : UInt<1>
    output io : {flip pc_fetch_imm : UInt<32>, pc_fetch_out : UInt<32>, flip pc_fetch_jump : UInt<1>, flip pc_fetch_jump2 : UInt<1>, flip pc_fetch_jump3 : UInt<1>, flip Imem_fetch_enable : UInt<1>, flip Imem_fetch_address : UInt<32>, Imem_fetch_out : UInt<32>}
    
    inst pcmod of pc @[fetch.scala 30:23]
    pcmod.clock <= clock
    pcmod.reset <= reset
    inst inmmod of Imem @[fetch.scala 31:24]
    inmmod.clock <= clock
    inmmod.reset <= reset
    inmmod.io.address <= pcmod.io.out @[fetch.scala 35:23]
    pcmod.io.imm <= io.pc_fetch_imm @[fetch.scala 39:18]
    pcmod.io.jump <= io.pc_fetch_jump @[fetch.scala 40:19]
    pcmod.io.jump2 <= io.pc_fetch_jump2 @[fetch.scala 41:20]
    pcmod.io.jump3 <= io.pc_fetch_jump3 @[fetch.scala 42:20]
    io.pc_fetch_out <= pcmod.io.out @[fetch.scala 46:21]
    inmmod.io.enable <= io.Imem_fetch_enable @[fetch.scala 50:22]
    inmmod.io.address <= io.Imem_fetch_address @[fetch.scala 51:23]
    io.Imem_fetch_out <= inmmod.io.out @[fetch.scala 52:26]
    
