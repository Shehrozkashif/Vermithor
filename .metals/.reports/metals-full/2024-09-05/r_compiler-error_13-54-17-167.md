file://<HOME>/Desktop/piplining/5%20stage%20pipielining%20processorold/src/main/scala/pipeline/execute.scala
### file%3A%2F%2F%2Fhome%2Fshehroz%2FDesktop%2Fpiplining%2F5%2520stage%2520pipielining%2520processorold%2Fsrc%2Fmain%2Fscala%2Fpipeline%2Fexecute.scala:147: error: illegal start of definition `identifier`
when(io.instructioncu(6,0) === "h37".U ){ // U type lui
^

occurred in the presentation compiler.

presentation compiler configuration:
Scala version: 2.12.19
Classpath:
<HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/scala-lang/scala-library/2.12.19/scala-library-2.12.19.jar [exists ]
Options:



action parameters:
uri: file://<HOME>/Desktop/piplining/5%20stage%20pipielining%20processorold/src/main/scala/pipeline/execute.scala
text:
```scala
package pipeline
import chisel3._
// import chisel3.stage.ChiselStage
import chisel3.util._
import chisel3.experimental.IO

class execute  extends Module {
  val io = IO(new Bundle {
    //ALU input/outputs for load and store
    val A = Input(UInt(32.W))    // both A and B for address calculation of memory
    val B = Input(UInt(32.W))
    val op = Input(UInt(4.W))
    val out = Output(UInt(32.W)) // not wired
 
    // catching the outputs of registerfile, decode module
    val rdata1 = Input ( UInt ( 32 . W ) ) //rs1 output
    val rdata2 = Input ( UInt ( 32 . W ) ) //rs2 output
    // val wenout = Output( Bool () ) // wenable input
    // val waddr = Input ( UInt (5. W ) )  //rd
    val wdata = Output ( UInt ( 32 . W ) ) // rd data  giving register file data to write 


    // catching input/outputs from control unit

    val instructioncu = Input(UInt(32.W))   // from decode module
    val func3_7 = Input(UInt(3.W))    // func3 --- op from decode (cu)
    // val en_imem = Output(Bool())  // imem enable
    // val en_reg = Output(Bool()) // reg enable
    // val rd = Output(UInt(5.W))
    // val rs2 = Output(UInt(5.W))
    // val rs1 = Output(UInt(5.W))
    // val immcu = Output(UInt(12.W))

    // catching input/outputs from immediate generator 
    // val instructionimm = Input(UInt(32.W))
    val immg = Input(UInt(32.W))  // from decode module (immgenr)



    // catching pc outputs/inputs from pc
    val pcout = Input(UInt(32.W))     // from pc inside fetch module
    val aluout = Output(UInt(32.W))// catching alu output, output of address calc for branch,jal,jalr
    val pcjump = Output(Bool())  // for B type instruction
    val pcjump2 = Output(Bool())  // for jal type instruction
    val pcjump3 = Output(Bool())  // for jalr type instruction

    // sending signal to datamemroy 
      // val wen_datamem = Output(Bool())
      val addr = Output(UInt(8.W))


  
  })  



  // calling objects
val alumod = Module(new alu)

io.pcjump3 := 0.B // default value
io.pcjump2 := 0.B // Default value
io.pcjump  := 0.B



// connections of execute module(alu) with decode module (register file) 

alumod.io.A := io.rdata1 
alumod.io.B := io.rdata2
alumod.io.op:=io.func3_7
io.out   := alumod.io.out    // from alu to execute module

io.wdata :=   alumod.io.out  // Default value for wdata
io.aluout := alumod.io.out      // branch address to pc (default value)
// when load and store 
io.addr := 0.U // default
when(io.instructioncu(6,0) === 3.U)
{
  alumod.io.A:=io.A
  alumod.io.B:=io.B
  alumod.io.op:=0.U
  io.addr := alumod.io.out(9,2)   // address of load 
}.elsewhen(io.instructioncu === "h23".U)
{
  alumod.io.A:=io.A
  alumod.io.B:=io.B
  alumod.io.op:=0.U
  io.addr := alumod.io.out(9,2)   // address of store
}




// alumod.io.A := io.rdata1
// alumod.io.B := io.rdata2


when(io.instructioncu(6,0) === "h33".U ){ // R type 
// alumod.io.A := regfmod.io.rdata1
alumod.io.B := io.rdata2
}
.elsewhen(io.instructioncu(6,0) === "h13".U){  // I type
alumod.io.B := io.immg       // assiging immediate to rs2
}


// branch type instruction 
when(io.instructioncu(6, 0) === 99.U) {
  alumod.io.op:= 0.U
  alumod.io.A := io.pcout
  alumod.io.B := io.immg    // immediate of branch
  // io.wen_datamem  := 1.B


  // io.addr := alumod.io.out(9,2)

    io.aluout := alumod.io.out      // branch address to pc
    when(io.instructioncu(14, 12) === 0.U) { // beq
      when(io.rdata1 === io.rdata2) {
      io.pcjump := true.B
      }
    }.elsewhen(io.instructioncu(14, 12) === 1.U) { // bne
      when(io.rdata1 =/= io.rdata2) {
        io.pcjump := true.B
      }
    }.elsewhen(io.instructioncu(14, 12) === 2.U) { // blt
      when(io.rdata1 < io.rdata2) {
        io.pcjump := true.B
      }
    }.elsewhen(io.instructioncu(14, 12) === 3.U) { // bge
      when(io.rdata1 >= io.rdata2) {
        io.pcjump := true.B
      }
    }.elsewhen(io.instructioncu(14, 12) === 4.U)  // bltu
      when(io.rdata1.asUInt < io.rdata2.asUInt()) {
        io.pcjump := true.B
      }
    }.elsewhen(io.instructioncu(14, 12) === 5.U) { // bgeu
      when(io.rdata1.asUInt >= io.rdata2.asUInt()) {
        io.pcjump := true.B
      }
    }

  }
// uuper immeidate type code

when(io.instructioncu(6,0) === "h37".U ){ // U type lui
io.wdata := io.immg      // write immediate destination register rd
}
when(io.instructioncu(6,0) === "h17".U ){ // U type auipc
alumod.io.op:= 0.U
  alumod.io.A := io.pcout
  alumod.io.B := io.immg
  // io.wen_datamem := 1.B
io.wdata :=   alumod.io.out     // writing upper immediate of auipc to register for auipc instruction
// val temp = Cat(immg.io.imm, Fill(12 ,0.U) )
// regfmod.io.wdata := temp + pcmod.io.out

}
when(io.instructioncu(6,0) === "h6f".U){   //jal
  io.pcjump2 := 1.B

  alumod.io.op:= 0.U
  alumod.io.A := io.pcout
  alumod.io.B := io.immg    // immediate of jal instruction 
  // io.wen_datamem := 1.B

  io.wdata :=   io.pcout + 4.U
  io.aluout := alumod.io.out   // jal instruction address to pc

}
when(io.instructioncu(6,0) === "h67".U){   //jalr
  io.pcjump3 := 1.B

  alumod.io.op:= 0.U
alumod.io.A := io.rdata1
  alumod.io.B := io.immg
  // io.wen_datamem := 1.B

  io.wdata :=   io.pcout + 4.U
  io.aluout := alumod.io.out     // jalr address to pc


}


}

```



#### Error stacktrace:

```
scala.meta.internal.parsers.Reporter.syntaxError(Reporter.scala:16)
	scala.meta.internal.parsers.Reporter.syntaxError$(Reporter.scala:16)
	scala.meta.internal.parsers.Reporter$$anon$1.syntaxError(Reporter.scala:22)
	scala.meta.internal.parsers.Reporter.syntaxError(Reporter.scala:17)
	scala.meta.internal.parsers.Reporter.syntaxError$(Reporter.scala:17)
	scala.meta.internal.parsers.Reporter$$anon$1.syntaxError(Reporter.scala:22)
	scala.meta.internal.parsers.ScalametaParser.statSeqBuf(ScalametaParser.scala:4109)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$statSeq$1(ScalametaParser.scala:4096)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$statSeq$1$adapted(ScalametaParser.scala:4096)
	scala.meta.internal.parsers.ScalametaParser.scala$meta$internal$parsers$ScalametaParser$$listBy(ScalametaParser.scala:562)
	scala.meta.internal.parsers.ScalametaParser.statSeq(ScalametaParser.scala:4096)
	scala.meta.internal.parsers.ScalametaParser.bracelessPackageStats$1(ScalametaParser.scala:4285)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$source$1(ScalametaParser.scala:4288)
	scala.meta.internal.parsers.ScalametaParser.atPos(ScalametaParser.scala:325)
	scala.meta.internal.parsers.ScalametaParser.autoPos(ScalametaParser.scala:369)
	scala.meta.internal.parsers.ScalametaParser.source(ScalametaParser.scala:4264)
	scala.meta.internal.parsers.ScalametaParser.entrypointSource(ScalametaParser.scala:4291)
	scala.meta.internal.parsers.ScalametaParser.parseSourceImpl(ScalametaParser.scala:119)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$parseSource$1(ScalametaParser.scala:116)
	scala.meta.internal.parsers.ScalametaParser.parseRuleAfterBOF(ScalametaParser.scala:58)
	scala.meta.internal.parsers.ScalametaParser.parseRule(ScalametaParser.scala:53)
	scala.meta.internal.parsers.ScalametaParser.parseSource(ScalametaParser.scala:116)
	scala.meta.parsers.Parse$.$anonfun$parseSource$1(Parse.scala:30)
	scala.meta.parsers.Parse$$anon$1.apply(Parse.scala:37)
	scala.meta.parsers.Api$XtensionParseDialectInput.parse(Api.scala:22)
	scala.meta.internal.semanticdb.scalac.ParseOps$XtensionCompilationUnitSource.toSource(ParseOps.scala:15)
	scala.meta.internal.semanticdb.scalac.TextDocumentOps$XtensionCompilationUnitDocument.toTextDocument(TextDocumentOps.scala:161)
	scala.meta.internal.pc.SemanticdbTextDocumentProvider.textDocument(SemanticdbTextDocumentProvider.scala:54)
	scala.meta.internal.pc.ScalaPresentationCompiler.$anonfun$semanticdbTextDocument$1(ScalaPresentationCompiler.scala:469)
```
#### Short summary: 

file%3A%2F%2F%2Fhome%2Fshehroz%2FDesktop%2Fpiplining%2F5%2520stage%2520pipielining%2520processorold%2Fsrc%2Fmain%2Fscala%2Fpipeline%2Fexecute.scala:147: error: illegal start of definition `identifier`
when(io.instructioncu(6,0) === "h37".U ){ // U type lui
^