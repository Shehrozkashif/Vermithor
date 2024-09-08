package singlecycle
import chisel3._
import chisel3.tester._
import org.scalatest.FreeSpec
import chisel3.experimental.BundleLiterals._
class ALUtest extends FreeSpec with ChiselScalatestTester{
"Chisel Tester File ALU" in {
    test(new alu){  a=>
    a.io.A.poke(1.U)
    a.io.B.poke(1.U)   
    a.io.op.poke(1.U) 
    a.clock.step(2)
    a.io.out.expect(2.U)
    
    }

}


}
