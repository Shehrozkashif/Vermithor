circuit fetch :
  module pc :
    input clock : Clock
    input reset : UInt<1>
    input io_imm : UInt<32>
    output io_out : UInt<32>
    input io_jump : UInt<1>

    reg pc : UInt<32>, clock with :
      reset => (UInt<1>("h0"), pc) @[pc.scala 21:19]
    node _pc_T = add(pc, UInt<3>("h4")) @[pc.scala 27:11]
    node _pc_T_1 = tail(_pc_T, 1) @[pc.scala 27:11]
    node _GEN_0 = mux(io_jump, io_imm, _pc_T_1) @[pc.scala 23:14 pc.scala 24:4 pc.scala 27:4]
    io_out <= pc @[pc.scala 30:8]
    pc <= mux(reset, UInt<32>("h0"), _GEN_0) @[pc.scala 21:19 pc.scala 21:19]

  module Imem :
    input clock : Clock
    input reset : UInt<1>
    input io_address : UInt<32>
    output io_out : UInt<32>

    mem memory : @[Imem.scala 11:17]
      data-type => UInt<32>
      depth => 1024
      read-latency => 0
      write-latency => 1
      reader => io_out_MPORT
      writer => MPORT
      read-under-write => undefined
    node _T = shr(io_address, 2) @[Imem.scala 17:26]
    node _T_1 = bits(_T, 9, 0)
    node _io_out_T = shr(io_address, 2) @[Imem.scala 19:35]
    node _io_out_T_1 = bits(_io_out_T, 9, 0) @[Imem.scala 19:22]
    io_out <= memory.io_out_MPORT.data @[Imem.scala 19:8]
    memory.io_out_MPORT.addr <= _io_out_T_1 @[Imem.scala 19:22]
    memory.io_out_MPORT.en <= UInt<1>("h1") @[Imem.scala 19:22]
    memory.io_out_MPORT.clk <= clock @[Imem.scala 19:22]
    memory.MPORT.addr <= _T_1
    memory.MPORT.en <= UInt<1>("h1")
    memory.MPORT.clk <= clock
    memory.MPORT.data <= UInt<1>("h0")
    memory.MPORT.mask <= UInt<1>("h1")

  module fetch :
    input clock : Clock
    input reset : UInt<1>
    output io_pc_fetch_out : UInt<32>
    output io_Imem_fetch_out : UInt<32>
    input io_pc_imm_execute : UInt<32>

    inst pcmod of pc @[fetch.scala 25:23]
    inst inmmod of Imem @[fetch.scala 26:24]
    node _T = bits(io_Imem_fetch_out, 6, 0) @[fetch.scala 50:27]
    node _T_1 = eq(_T, UInt<7>("h63")) @[fetch.scala 50:34]
    node _T_2 = bits(io_Imem_fetch_out, 6, 0) @[fetch.scala 50:63]
    node _T_3 = eq(_T_2, UInt<7>("h6f")) @[fetch.scala 50:69]
    node _T_4 = or(_T_1, _T_3) @[fetch.scala 50:43]
    node _GEN_0 = mux(_T_4, UInt<1>("h1"), UInt<1>("h0")) @[fetch.scala 50:82 fetch.scala 51:23 fetch.scala 54:21]
    io_pc_fetch_out <= pcmod.io_out @[fetch.scala 44:21]
    io_Imem_fetch_out <= inmmod.io_out @[fetch.scala 48:23]
    pcmod.clock <= clock
    pcmod.reset <= reset
    pcmod.io_imm <= io_pc_imm_execute @[fetch.scala 39:18]
    pcmod.io_jump <= _GEN_0
    inmmod.clock <= clock
    inmmod.reset <= reset
    inmmod.io_address <= pcmod.io_out @[fetch.scala 35:23]
