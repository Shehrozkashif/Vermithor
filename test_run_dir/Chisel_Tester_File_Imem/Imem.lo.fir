circuit Imem :
  module Imem :
    input clock : Clock
    input reset : UInt<1>
    input io_data_in : UInt<32>
    input io_enable : UInt<1>
    input io_address : UInt<32>
    output io_out : UInt<32>

    mem memory : @[Imem.scala 13:17]
      data-type => UInt<32>
      depth => 256
      read-latency => 0
      write-latency => 1
      reader => io_out_MPORT
      writer => MPORT
      read-under-write => undefined
    node _T = shr(io_address, 2) @[Imem.scala 19:26]
    node _T_1 = bits(_T, 7, 0)
    node _GEN_0 = validif(io_enable, _T_1) @[Imem.scala 18:20]
    node _GEN_1 = validif(io_enable, clock) @[Imem.scala 18:20]
    node _GEN_2 = mux(io_enable, UInt<1>("h1"), UInt<1>("h0")) @[Imem.scala 18:20 Imem.scala 13:17]
    node _GEN_3 = validif(io_enable, UInt<1>("h1")) @[Imem.scala 18:20]
    node _GEN_4 = validif(io_enable, io_data_in) @[Imem.scala 18:20]
    node _io_out_T = shr(io_address, 2) @[Imem.scala 21:35]
    node _io_out_T_1 = bits(_io_out_T, 7, 0) @[Imem.scala 21:22]
    io_out <= memory.io_out_MPORT.data @[Imem.scala 21:8]
    memory.io_out_MPORT.addr <= _io_out_T_1 @[Imem.scala 21:22]
    memory.io_out_MPORT.en <= UInt<1>("h1") @[Imem.scala 21:22]
    memory.io_out_MPORT.clk <= clock @[Imem.scala 21:22]
    memory.MPORT.addr <= _GEN_0
    memory.MPORT.en <= _GEN_2
    memory.MPORT.clk <= _GEN_1
    memory.MPORT.data <= _GEN_4
    memory.MPORT.mask <= _GEN_3
