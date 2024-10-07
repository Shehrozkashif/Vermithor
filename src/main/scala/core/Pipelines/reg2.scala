package Pipeline

import chisel3._
import chisel3.util._

class reg1 extends Module {
    val io = IO(new Bundle {

       
        val pc_reg2 = Input (UInt(32.W))
        val rdata1_reg2 = Input (SInt(32.W))
        val rdata2_reg2 = Input (SInt(32.W))
        val immgen_reg2 = Input (UInt(32.W))

        val pc_reg2_out = Output (UInt(32.W))
        val rdata1_reg2_out = Output (SInt(32.W))
        val rdata2_reg2_out = Output (SInt(32.W))
        val immgen_reg2_out = Output (UInt(32.W))
 

    })

    val pc = RegInit (0.S (32.W))
    val rdata1  = RegInit (0.U (32.W))
    val rdata2 = RegInit (0.S (32.W))
    val immgen  = RegInit (0.U (32.W))
    
    
    pc := pc_reg2
    rdata1 := rdata1_reg2
    rdata2 := rdata2_reg2
    immgen := immgen_reg2


    pc_reg2_out := pc
    rdata1_reg2_out := rdata1
    rdata2_reg2_out := rdata2
    immgen_reg2_out := immgen


}

