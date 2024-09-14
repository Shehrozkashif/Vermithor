;buildInfoPackage: chisel3, version: 3.4.3, scalaVersion: 2.12.12, sbtVersion: 1.3.10
circuit datamemory : 
  module datamemory : 
    input clock : Clock
    input reset : UInt<1>
    output io : {out : UInt<32>, flip datain : UInt<32>, flip addr : UInt<8>, flip rd_enable : UInt<1>, flip wr_enable : UInt<1>}
    
    io.out <= UInt<1>("h00") @[datamemory.scala 14:9]
    cmem memory : UInt<8>[1024] @[datamemory.scala 19:19]
    when io.wr_enable : @[datamemory.scala 22:22]
      write mport MPORT = memory[io.addr], clock
      MPORT <= io.datain
      skip @[datamemory.scala 22:22]
    when io.rd_enable : @[datamemory.scala 25:22]
      read mport io_out_MPORT = memory[io.addr], clock @[datamemory.scala 26:26]
      io.out <= io_out_MPORT @[datamemory.scala 26:12]
      skip @[datamemory.scala 25:22]
    
