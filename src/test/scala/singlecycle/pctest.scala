
package singlecycle
import chisel3._
import chisel3.tester._
import org.scalatest.FreeSpec
import chisel3.experimental.BundleLiterals._
class pctest extends FreeSpec with ChiselScalatestTester{
"Chisel Tester File pc" in {
    test(new pc){  a=>

a.clock.step(1)
a.io.out.expect(4.U)
    }
}
}