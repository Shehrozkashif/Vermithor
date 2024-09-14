package core
import chisel3._
import chisel3.util._
import chisel3.util.experimental.loadMemoryFromFile
class datamemory extends Module {
  val io = IO(new Bundle {
  val out = Output( UInt ( 32 . W ) )
   val datain = Input( UInt ( 32 . W ) )
  val addr = Input(UInt(8.W)) // Changed the address width to 8 bits
  val rd_enable = Input(Bool())
  val wr_enable = Input(Bool())

  })
  io.out:=0.U




  val memory = Mem(1024, UInt(8.W) )

  // memory write operation
  when(io.wr_enable) {
    memory.write(io.addr,  io.datain)
  }
  when(io.rd_enable) {
    io.out := memory.read(io.addr)
    // io.out := memory.read(io.addr, io.rd_enable)





  }
  
}