package Pipeline

import chisel3._
import chisel3.util._

class reg1 extends Module {
    val io = IO(new Bundle {
        val instruction_reg1 = Input (SInt(32.W))
        val pc_reg1 = Input (UInt(32.W))

        val instruction_reg1_out = Output (SInt(32.W))      
        val pc_reg1_out = Output (UInt(32.W))    

    })

    val ins = RegInit (0.S (32.W))
    val pc  = RegInit (0.U (32.W))
    

    ins := instruction_reg1
    pc := pc_reg1


    io.instruction_reg1_out := ins
    io.pc_reg1_out := pc


}

    