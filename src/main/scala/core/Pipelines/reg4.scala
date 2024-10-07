package Pipeline

import chisel3._
import chisel3.util._

class reg4 extends Module {
    val io = IO(new Bundle {
        val datamemout_reg4 = Input (SInt(32.W))
        val aluout_reg4 = Input (UInt(32.W))

        val  datamemout_reg4_out = Output (SInt(32.W))      
        val aluout_reg4_out = Output (UInt(32.W))    

    })

    val datamem_out = RegInit (0.S (32.W))
    val aluout  = RegInit (0.U (32.W))
    

    pcimm := io.datamem_out_reg4
    alu := io.aluout_reg4


    io.pc_imm_reg3_out := datamem_out
    io.aluout_reg3_out := aluout


}

    