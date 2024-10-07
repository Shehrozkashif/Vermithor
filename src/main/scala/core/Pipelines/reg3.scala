package Pipeline

import chisel3._
import chisel3.util._

class reg3 extends Module {
    val io = IO(new Bundle {
        val pc_imm_reg3 = Input (SInt(32.W))
        val aluout_reg3 = Input (UInt(32.W))

        val  pc_imm_reg3_out = Output (SInt(32.W))      
        val aluout_reg3_out = Output (UInt(32.W))    

    })

    val pcimm = RegInit (0.S (32.W))
    val aluout  = RegInit (0.U (32.W))
    

    pcimm := io.pc_imm_reg3
    alu := io.aluout_reg3


    io.pc_imm_reg3_out := pcimm
    io.aluout_reg3_out := alu


}

    