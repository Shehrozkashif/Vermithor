package core
import chisel3._
import chisel3.tester._
import org.scalatest.FreeSpec
import chisel3.experimental.BundleLiterals._
class registerfiletest extends FreeSpec with ChiselScalatestTester{
"Chisel Tester File mem" in {
    test(new registerfile){  a=>
a.io.raddr1.poke(1.U)
a.io.raddr2.poke(1.U)
a.io.waddr.poke(1.U)
a.io.wdata.poke(1.U)
a.io.wen.poke(1.B)
a.clock.step(1)
a.io.rdata1.expect(1.U)
a.io.rdata2.expect(1.U)

    }
}
}