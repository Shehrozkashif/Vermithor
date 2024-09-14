circuit datamemory :
  module datamemory :
    input clock : Clock
    input reset : UInt<1>
    output io_out : UInt<32>
    input io_datain : UInt<32>
    input io_addr : UInt<8>
    input io_rd_enable : UInt<1>
    input io_wr_enable : UInt<1>

    mem memory : @[datamemory.scala 19:19]
      data-type => UInt<8>
      depth => 1024
      read-latency => 0
      write-latency => 1
      reader => io_out_MPORT
      writer => MPORT
      read-under-write => undefined
    node _GEN_0 = validif(io_wr_enable, io_addr) @[datamemory.scala 22:22]
    node _GEN_1 = validif(io_wr_enable, clock) @[datamemory.scala 22:22]
    node _GEN_2 = mux(io_wr_enable, UInt<1>("h1"), UInt<1>("h0")) @[datamemory.scala 22:22 datamemory.scala 19:19]
    node _GEN_3 = validif(io_wr_enable, UInt<1>("h1")) @[datamemory.scala 22:22]
    node _GEN_4 = validif(io_wr_enable, io_datain) @[datamemory.scala 22:22]
    node _GEN_5 = validif(io_rd_enable, io_addr) @[datamemory.scala 25:22 datamemory.scala 26:26]
    node _GEN_6 = validif(io_rd_enable, clock) @[datamemory.scala 25:22 datamemory.scala 26:26]
    node _GEN_7 = mux(io_rd_enable, UInt<1>("h1"), UInt<1>("h0")) @[datamemory.scala 25:22 datamemory.scala 26:26 datamemory.scala 19:19]
    node _GEN_8 = mux(io_rd_enable, memory.io_out_MPORT.data, UInt<1>("h0")) @[datamemory.scala 25:22 datamemory.scala 26:12 datamemory.scala 14:9]
    io_out <= _GEN_8
    memory.io_out_MPORT.addr <= _GEN_5
    memory.io_out_MPORT.en <= _GEN_7
    memory.io_out_MPORT.clk <= _GEN_6
    memory.MPORT.addr <= _GEN_0
    memory.MPORT.en <= _GEN_2
    memory.MPORT.clk <= _GEN_1
    memory.MPORT.data <= bits(_GEN_4, 7, 0)
    memory.MPORT.mask <= _GEN_3
