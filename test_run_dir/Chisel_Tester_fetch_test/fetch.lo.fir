circuit fetch :
  module pc :
    input clock : Clock
    input reset : UInt<1>
    input io_imm : UInt<32>
    output io_out : UInt<32>
    input io_jump : UInt<1>
    input io_jump2 : UInt<1>
    input io_jump3 : UInt<1>

    reg pc : UInt<32>, clock with :
      reset => (UInt<1>("h0"), pc) @[pc.scala 20:19]
    node _pc_T = add(pc, UInt<3>("h4")) @[pc.scala 26:11]
    node _pc_T_1 = tail(_pc_T, 1) @[pc.scala 26:11]
    node _GEN_0 = mux(io_jump, io_imm, _pc_T_1) @[pc.scala 22:14 pc.scala 23:4 pc.scala 26:4]
    node _T = eq(pc, UInt<11>("h400")) @[pc.scala 28:9]
    node _GEN_1 = mux(_T, UInt<1>("h0"), _GEN_0) @[pc.scala 28:17 pc.scala 29:4]
    node _GEN_2 = mux(io_jump2, io_imm, _GEN_1) @[pc.scala 31:16 pc.scala 33:4]
    node _GEN_3 = mux(io_jump3, io_imm, _GEN_2) @[pc.scala 36:16 pc.scala 37:4]
    io_out <= pc @[pc.scala 40:8]
    pc <= mux(reset, UInt<32>("h0"), _GEN_3) @[pc.scala 20:19 pc.scala 20:19]

  module Imem :
    input clock : Clock
    input reset : UInt<1>
    input io_enable : UInt<1>
    input io_address : UInt<32>
    output io_out : UInt<32>

    mem memory : @[Imem.scala 15:19]
      data-type => UInt<32>
      depth => 256
      read-latency => 0
      write-latency => 1
      reader => io_out_MPORT
      read-under-write => undefined
    node _io_out_T = shr(io_address, 2) @[Imem.scala 26:36]
    node _io_out_T_1 = bits(_io_out_T, 7, 0) @[Imem.scala 26:24]
    io_out <= memory.io_out_MPORT.data @[Imem.scala 26:10]
    memory.io_out_MPORT.addr <= _io_out_T_1 @[Imem.scala 26:24]
    memory.io_out_MPORT.en <= UInt<1>("h1") @[Imem.scala 26:24]
    memory.io_out_MPORT.clk <= clock @[Imem.scala 26:24]

  module fetch :
    input clock : Clock
    input reset : UInt<1>
    input io_pc_fetch_imm : UInt<32>
    output io_pc_fetch_out : UInt<32>
    input io_pc_fetch_jump : UInt<1>
    input io_pc_fetch_jump2 : UInt<1>
    input io_pc_fetch_jump3 : UInt<1>
    input io_Imem_fetch_enable : UInt<1>
    input io_Imem_fetch_address : UInt<32>
    output io_Imem_fetch_out : UInt<32>

    inst pcmod of pc @[fetch.scala 30:23]
    inst inmmod of Imem @[fetch.scala 31:24]
    io_pc_fetch_out <= pcmod.io_out @[fetch.scala 46:21]
    io_Imem_fetch_out <= inmmod.io_out @[fetch.scala 52:26]
    pcmod.clock <= clock
    pcmod.reset <= reset
    pcmod.io_imm <= io_pc_fetch_imm @[fetch.scala 39:18]
    pcmod.io_jump <= io_pc_fetch_jump @[fetch.scala 40:19]
    pcmod.io_jump2 <= io_pc_fetch_jump2 @[fetch.scala 41:20]
    pcmod.io_jump3 <= io_pc_fetch_jump3 @[fetch.scala 42:20]
    inmmod.clock <= clock
    inmmod.reset <= reset
    inmmod.io_enable <= io_Imem_fetch_enable @[fetch.scala 50:22]
    inmmod.io_address <= io_Imem_fetch_address @[fetch.scala 51:23]
