package core
import chisel3._
import chisel3.util._
// import chisel3.util.experimental.experimentalloadMemoryFromFile
import chisel3.util.experimental.loadMemoryFromFile
class Imem extends Module {
val io = IO (new Bundle {
  val address= Input(UInt(32.W))
  val out= Output(UInt(32.W))
})
val memory = Mem(1024, UInt(32.W))
 

loadMemoryFromFile(memory,"src/main/scala/core/inst_file.txt")


memory.write( io.address >> 2 , 0.U  )

io.out := memory.read( io.address >> 2)
}

