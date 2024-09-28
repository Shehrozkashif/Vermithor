package core
import chisel3._
import chisel3.tester._
import org.scalatest.FreeSpec
import chisel3.experimental.BundleLiterals._
class executetest extends FreeSpec with ChiselScalatestTester{
"Chisel Tester File executetest" in {
    test(new execute){  a=>
   
    a.clock.step(20)
    // a.io.output.expect(104.U)
    }

}
}