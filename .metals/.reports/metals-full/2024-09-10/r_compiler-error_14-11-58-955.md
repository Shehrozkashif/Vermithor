file://<HOME>/Desktop/New%20Folder%203/Vermithor/src/main/scala/core/decode.scala
### scala.reflect.internal.FatalError: 
  unexpected tree: class scala.reflect.internal.Trees$Template
<Bundle: error> {
  def <init>(): <$anon: <error>> = {
    super.<init>();
    ()
  };
  private[this] val <decode_instruction: error>: <error> = <Input: error>(<UInt: error>(32.<W: error>));
  private[this] val <decode_func3_7: error>: <error> = <Output: error>(<UInt: error>(3.<W: error>));
  private[this] val <decode_en_imem: error>: <error> = <Output: error>(<Bool: error>());
  private[this] val <decode_en_reg: error>: <error> = <Output: error>(<Bool: error>());
  private[this] val <decode_rd: error>: <error> = <Output: error>(<UInt: error>(5.<W: error>));
  private[this] val <decode_rs2: error>: <error> = <Output: error>(<UInt: error>(5.<W: error>));
  private[this] val <decode_rs1: error>: <error> = <Output: error>(<UInt: error>(5.<W: error>));
  private[this] val <decode_imm: error>: <error> = <Output: error>(<UInt: error>(12.<W: error>));
  private[this] val <decode_immgenr_instruction: error>: <error> = <Input: error>(<UInt: error>(32.<W: error>));
  private[this] val <decode_imm_out: error>: <error> = <Output: error>(<UInt: error>(32.<W: error>))
}
     while compiling: file://<HOME>/Desktop/New%20Folder%203/Vermithor/src/main/scala/core/decode.scala
        during phase: globalPhase=<no phase>, enteringPhase=parser
     library version: version 2.12.19
    compiler version: version 2.12.19
  reconstructed args: -classpath <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/scala-lang/scala-library/2.12.19/scala-library-2.12.19.jar -Ymacro-expand:discard -Ycache-plugin-class-loader:last-modified -Ypresentation-any-thread

  last tree to typer: Template(value <local $anon>)
       tree position: line 7 of file://<HOME>/Desktop/New%20Folder%203/Vermithor/src/main/scala/core/decode.scala
              symbol: value <local $anon>
   symbol definition: val <local $anon>: <notype> (a TermSymbol)
      symbol package: core
       symbol owners: value <local $anon> -> <$anon: <error>> -> value io -> class decode
           call site: <none> in <none>

== Source file context for tree position ==

     4 
     5 
     6 class decode extends Module{
     7 val io = IO(new Bundle{
     8     // control unit inputs and outputs
     9     val decode_instruction = Input(UInt(32.W))
    10     val decode_func3_7 = Output(UInt(3.W))

occurred in the presentation compiler.

presentation compiler configuration:
Scala version: 2.12.19
Classpath:
<HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/scala-lang/scala-library/2.12.19/scala-library-2.12.19.jar [exists ]
Options:



action parameters:
offset: 673
uri: file://<HOME>/Desktop/New%20Folder%203/Vermithor/src/main/scala/core/decode.scala
text:
```scala
package core
import chisel3._
import chisel3.util._


class decode extends Module{
val io = IO(new Bundle{
    // control unit inputs and outputs
    val decode_instruction = Input(UInt(32.W))
    val decode_func3_7 = Output(UInt(3.W))
    val decode_en_imem = Output(Bool())  // imem enable
    val decode_en_reg = Output(Bool()) // reg enable
    val decode_rd = Output(UInt(5.W))
    val decode_rs2 = Output(UInt(5.W))
    val decode_rs1 = Output(UInt(5.W))
    val decode_imm = Output(UInt(12.W))


    // immediate generator inputs and outputs
    val decode_immgenr_instruction = Input(UInt(32.W))
    val decode_imm_out = Output(UInt(32.W))


    // register_file in@@puts and outputs
    

  } )  


    // making instances
    val cumod = Module(new controlunit)
    val immg = Module(new immgenr)
    val regfmod = Module(new registerfile)

    // connections between 



   

    






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
  private[this] val <decode_instruction: error>: <error> = <Input: error>(<UInt: error>(32.<W: error>));
  private[this] val <decode_func3_7: error>: <error> = <Output: error>(<UInt: error>(3.<W: error>));
  private[this] val <decode_en_imem: error>: <error> = <Output: error>(<Bool: error>());
  private[this] val <decode_en_reg: error>: <error> = <Output: error>(<Bool: error>());
  private[this] val <decode_rd: error>: <error> = <Output: error>(<UInt: error>(5.<W: error>));
  private[this] val <decode_rs2: error>: <error> = <Output: error>(<UInt: error>(5.<W: error>));
  private[this] val <decode_rs1: error>: <error> = <Output: error>(<UInt: error>(5.<W: error>));
  private[this] val <decode_imm: error>: <error> = <Output: error>(<UInt: error>(12.<W: error>));
  private[this] val <decode_immgenr_instruction: error>: <error> = <Input: error>(<UInt: error>(32.<W: error>));
  private[this] val <decode_imm_out: error>: <error> = <Output: error>(<UInt: error>(32.<W: error>))
}
     while compiling: file://<HOME>/Desktop/New%20Folder%203/Vermithor/src/main/scala/core/decode.scala
        during phase: globalPhase=<no phase>, enteringPhase=parser
     library version: version 2.12.19
    compiler version: version 2.12.19
  reconstructed args: -classpath <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/scala-lang/scala-library/2.12.19/scala-library-2.12.19.jar -Ymacro-expand:discard -Ycache-plugin-class-loader:last-modified -Ypresentation-any-thread

  last tree to typer: Template(value <local $anon>)
       tree position: line 7 of file://<HOME>/Desktop/New%20Folder%203/Vermithor/src/main/scala/core/decode.scala
              symbol: value <local $anon>
   symbol definition: val <local $anon>: <notype> (a TermSymbol)
      symbol package: core
       symbol owners: value <local $anon> -> <$anon: <error>> -> value io -> class decode
           call site: <none> in <none>

== Source file context for tree position ==

     4 
     5 
     6 class decode extends Module{
     7 val io = IO(new Bundle{
     8     // control unit inputs and outputs
     9     val decode_instruction = Input(UInt(32.W))
    10     val decode_func3_7 = Output(UInt(3.W))