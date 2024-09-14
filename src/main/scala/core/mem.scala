package core
import chisel3._
import chisel3.util._


class mem extends Module{
val io = IO(new Bundle{
    val out_mem = Output( UInt ( 32 . W ) )
    val datain_mem = Input( UInt ( 32 . W ) )
    val addr_mem = Input(UInt(8.W)) // Changed the address width to 8 bits
    val rd_enable_mem = Input(Bool())
    val wr_enable_mem = Input(Bool())


  } )  



    // calling the objects 
    val datamemorymod = Module(new datamemory)


    // connections between data memory with mem stage
    datamemorymod.io.datain := io.datain_mem
    datamemorymod.io.addr := io.addr_mem
    datamemorymod.io.rd_enable := io.rd_enable_mem
    datamemorymod.io.wr_enable := io.wr_enable_mem
    io.out_mem := datamemorymod.io.out

}