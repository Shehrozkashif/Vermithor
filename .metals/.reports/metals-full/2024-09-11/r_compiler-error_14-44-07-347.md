file://<HOME>/Desktop/New%20Folder%203/Vermithor/src/main/scala/core/controlunit.scala
### scala.reflect.internal.FatalError: 
  unexpected tree: class scala.reflect.internal.Trees$Template
<Bundle: error> {
  def <init>(): <$anon: <error>> = {
    super.<init>();
    ()
  };
  private[this] val <instruction: error>: <error> = <Input: error>(<UInt: error>(32.<W: error>));
  private[this] val <func3_7: error>: <error> = <Output: error>(<UInt: error>(3.<W: error>));
  private[this] val <en_reg: error>: <error> = <Output: error>(<Bool: error>());
  private[this] val <rd: error>: <error> = <Output: error>(<UInt: error>(5.<W: error>));
  private[this] val <rs2: error>: <error> = <Output: error>(<UInt: error>(5.<W: error>));
  private[this] val <rs1: error>: <error> = <Output: error>(<UInt: error>(5.<W: error>));
  private[this] val <imm: error>: <error> = <Output: error>(<UInt: error>(12.<W: error>))
}
     while compiling: file://<HOME>/Desktop/New%20Folder%203/Vermithor/src/main/scala/core/controlunit.scala
        during phase: globalPhase=<no phase>, enteringPhase=parser
     library version: version 2.12.19
    compiler version: version 2.12.19
  reconstructed args: -classpath <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/scala-lang/scala-library/2.12.19/scala-library-2.12.19.jar -Ymacro-expand:discard -Ycache-plugin-class-loader:last-modified -Ypresentation-any-thread

  last tree to typer: Template(value <local $anon>)
       tree position: line 5 of file://<HOME>/Desktop/New%20Folder%203/Vermithor/src/main/scala/core/controlunit.scala
              symbol: value <local $anon>
   symbol definition: val <local $anon>: <notype> (a TermSymbol)
      symbol package: core
       symbol owners: value <local $anon> -> <$anon: <error>> -> value io -> class controlunit
           call site: <none> in <none>

== Source file context for tree position ==

     2 import chisel3._
     3 import chisel3.util._
     4 class controlunit extends Module{
     5 val io = IO(new Bundle{
     6 val instruction = Input(UInt(32.W))
     7 val func3_7 = Output(UInt(3.W))
     8 val en_reg = Output(Bool()) // reg enable

occurred in the presentation compiler.

presentation compiler configuration:
Scala version: 2.12.19
Classpath:
<HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/scala-lang/scala-library/2.12.19/scala-library-2.12.19.jar [exists ]
Options:



action parameters:
offset: 211
uri: file://<HOME>/Desktop/New%20Folder%203/Vermithor/src/main/scala/core/controlunit.scala
text:
```scala
package core
import chisel3._
import chisel3.util._
class controlunit extends Module{
val io = IO(new Bundle{
val instruction = Input(UInt(32.W))
val func3_7 = Output(UInt(3.W))
val en_reg = Output(Bool()) // re@@g enable
val rd = Output(UInt(5.W))
val rs2 = Output(UInt(5.W))
val rs1 = Output(UInt(5.W))
val imm = Output(UInt(12.W))
} )
// val op = io.instruction(6,0)
io.en_reg := 0.B
io.func3_7 := 0.U

when(io.instruction(6,0) === 51.U)
{
  io.func3_7 := Cat(io.instruction(30),io.instruction(14,12))
  io.en_reg := 1.B
}.elsewhen(io.instruction(6,0) === 19.U )
{
    io.func3_7 := io.instruction(14,12)
    when(io.instruction(14,12 ) === 5.U)
    {
      io.func3_7 := Cat(io.instruction(30),io.instruction(14,12))
    }
    io.en_reg := 1.B
}.elsewhen(io.instruction(6,0) === 3.U ) // Load
{
    io.func3_7 := io.instruction(14,12)
    io.en_reg := 1.B
}.elsewhen(io.instruction(6,0) === "h23".U)  // Store 
{
    io.func3_7 := io.instruction(14,12)
    io.en_reg := 0.B
}.elsewhen(io.instruction(6,0) === "h6f".U){
  io.en_reg := 1.B
}
 
 io.rd := io.instruction(11,7) 
 io.rs1 := io.instruction(19,15)
 io.rs2 := io.instruction(24,20)
 io.imm := io.instruction(31,20)
// data mmeory wenable and renable 

  }
```



#### Error stacktrace:

```
scala.reflect.internal.Reporting.abort(Reporting.scala:69)
	scala.reflect.internal.Reporting.abort$(Reporting.scala:65)
	scala.reflect.internal.SymbolTable.abort(SymbolTable.scala:28)
	scala.tools.nsc.typechecker.Typers$Typer.typedOutsidePatternMode$1(Typers.scala:5765)
	scala.tools.nsc.typechecker.Typers$Typer.typed1(Typers.scala:5782)
	scala.tools.nsc.typechecker.Typers$Typer.typed(Typers.scala:5817)
	scala.tools.nsc.typechecker.Typers$Typer.typedQualifier(Typers.scala:5901)
	scala.meta.internal.pc.PcDefinitionProvider.definitionTypedTreeAt(PcDefinitionProvider.scala:160)
	scala.meta.internal.pc.PcDefinitionProvider.definition(PcDefinitionProvider.scala:68)
	scala.meta.internal.pc.PcDefinitionProvider.definition(PcDefinitionProvider.scala:16)
	scala.meta.internal.pc.ScalaPresentationCompiler.$anonfun$definition$1(ScalaPresentationCompiler.scala:393)
```
#### Short summary: 

scala.reflect.internal.FatalError: 
  unexpected tree: class scala.reflect.internal.Trees$Template
<Bundle: error> {
  def <init>(): <$anon: <error>> = {
    super.<init>();
    ()
  };
  private[this] val <instruction: error>: <error> = <Input: error>(<UInt: error>(32.<W: error>));
  private[this] val <func3_7: error>: <error> = <Output: error>(<UInt: error>(3.<W: error>));
  private[this] val <en_reg: error>: <error> = <Output: error>(<Bool: error>());
  private[this] val <rd: error>: <error> = <Output: error>(<UInt: error>(5.<W: error>));
  private[this] val <rs2: error>: <error> = <Output: error>(<UInt: error>(5.<W: error>));
  private[this] val <rs1: error>: <error> = <Output: error>(<UInt: error>(5.<W: error>));
  private[this] val <imm: error>: <error> = <Output: error>(<UInt: error>(12.<W: error>))
}
     while compiling: file://<HOME>/Desktop/New%20Folder%203/Vermithor/src/main/scala/core/controlunit.scala
        during phase: globalPhase=<no phase>, enteringPhase=parser
     library version: version 2.12.19
    compiler version: version 2.12.19
  reconstructed args: -classpath <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/scala-lang/scala-library/2.12.19/scala-library-2.12.19.jar -Ymacro-expand:discard -Ycache-plugin-class-loader:last-modified -Ypresentation-any-thread

  last tree to typer: Template(value <local $anon>)
       tree position: line 5 of file://<HOME>/Desktop/New%20Folder%203/Vermithor/src/main/scala/core/controlunit.scala
              symbol: value <local $anon>
   symbol definition: val <local $anon>: <notype> (a TermSymbol)
      symbol package: core
       symbol owners: value <local $anon> -> <$anon: <error>> -> value io -> class controlunit
           call site: <none> in <none>

== Source file context for tree position ==

     2 import chisel3._
     3 import chisel3.util._
     4 class controlunit extends Module{
     5 val io = IO(new Bundle{
     6 val instruction = Input(UInt(32.W))
     7 val func3_7 = Output(UInt(3.W))
     8 val en_reg = Output(Bool()) // reg enable