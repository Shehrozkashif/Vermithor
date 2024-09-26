file://<HOME>/Desktop/New%20Folder%203/Vermithor/src/main/scala/core/fetch.scala
### scala.reflect.internal.FatalError: 
  unexpected tree: class scala.reflect.internal.Trees$Template
<Bundle: error> {
  def <init>(): <$anon: <error>> = {
    super.<init>();
    ()
  };
  private[this] val <pc_fetch_out: error>: <error> = <Output: error>(<UInt: error>(32.<W: error>));
  private[this] val <Imem_fetch_out: error>: <error> = <Output: error>(<UInt: error>(32.<W: error>));
  private[this] val <pc_imm_execute: error>: <error> = <Input: error>(<UInt: error>(32.<W: error>))
}
     while compiling: file://<HOME>/Desktop/New%20Folder%203/Vermithor/src/main/scala/core/fetch.scala
        during phase: globalPhase=<no phase>, enteringPhase=parser
     library version: version 2.12.19
    compiler version: version 2.12.19
  reconstructed args: -classpath <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/scala-lang/scala-library/2.12.19/scala-library-2.12.19.jar -Ymacro-expand:discard -Ycache-plugin-class-loader:last-modified -Ypresentation-any-thread

  last tree to typer: Template(value <local $anon>)
       tree position: line 7 of file://<HOME>/Desktop/New%20Folder%203/Vermithor/src/main/scala/core/fetch.scala
              symbol: value <local $anon>
   symbol definition: val <local $anon>: <notype> (a TermSymbol)
      symbol package: core
       symbol owners: value <local $anon> -> <$anon: <error>> -> value io -> class fetch
           call site: <none> in <none>

== Source file context for tree position ==

     4 
     5 
     6 class fetch extends Module{
     7 val io = IO(new Bundle{
     8     //pc_inputs and outputs
     9     val pc_fetch_out = Output(UInt(32.W))
    10     

occurred in the presentation compiler.

presentation compiler configuration:
Scala version: 2.12.19
Classpath:
<HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/scala-lang/scala-library/2.12.19/scala-library-2.12.19.jar [exists ]
Options:



action parameters:
offset: 340
uri: file://<HOME>/Desktop/New%20Folder%203/Vermithor/src/main/scala/core/fetch.scala
text:
```scala
package core
import chisel3._
import chisel3.util._


class fetch extends Module{
val io = IO(new Bundle{
    //pc_inputs and outputs
    val pc_fetch_out = Output(UInt(32.W))
    
    
    // instruction memory inputs and outputs
    // val Imem_fetch_enable  = Input(Bool()) // check
    val Imem_fetch_out = Output(UInt(32.W))


    // p@@c + imm
    // reciving imm from execute 
    val pc_imm_execute = Input(UInt(32.W))


  } )  

    
    // making instances
    val pcmod = Module(new pc)
    val inmmod = Module(new Imem)


    // connections between  instruction memory and pc
    inmmod.io.address := pcmod.io.out


    // connections between pc and fetch_module inputs
    pcmod.io.imm := io.pc_imm_execute
   

    
    // connections between pc and fetch_module outputs
    io.pc_fetch_out := pcmod.io.out 


     // connections between instruction and fetch_module inputs
    inmmod.io.address := pcmod.io.out // asigning pc out to instruction mem
    io.Imem_fetch_out := inmmod.io.out 

    when(io.Imem_fetch_out(6, 0) === 99.U || io.Imem_fetch_out(6,0) === "h6f".U) { // branch and jal and jalr
        pcmod.io.jump := true.B
    }
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
  private[this] val <pc_fetch_out: error>: <error> = <Output: error>(<UInt: error>(32.<W: error>));
  private[this] val <Imem_fetch_out: error>: <error> = <Output: error>(<UInt: error>(32.<W: error>));
  private[this] val <pc_imm_execute: error>: <error> = <Input: error>(<UInt: error>(32.<W: error>))
}
     while compiling: file://<HOME>/Desktop/New%20Folder%203/Vermithor/src/main/scala/core/fetch.scala
        during phase: globalPhase=<no phase>, enteringPhase=parser
     library version: version 2.12.19
    compiler version: version 2.12.19
  reconstructed args: -classpath <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/scala-lang/scala-library/2.12.19/scala-library-2.12.19.jar -Ymacro-expand:discard -Ycache-plugin-class-loader:last-modified -Ypresentation-any-thread

  last tree to typer: Template(value <local $anon>)
       tree position: line 7 of file://<HOME>/Desktop/New%20Folder%203/Vermithor/src/main/scala/core/fetch.scala
              symbol: value <local $anon>
   symbol definition: val <local $anon>: <notype> (a TermSymbol)
      symbol package: core
       symbol owners: value <local $anon> -> <$anon: <error>> -> value io -> class fetch
           call site: <none> in <none>

== Source file context for tree position ==

     4 
     5 
     6 class fetch extends Module{
     7 val io = IO(new Bundle{
     8     //pc_inputs and outputs
     9     val pc_fetch_out = Output(UInt(32.W))
    10     