file://<HOME>/Desktop/New%20Folder%203/Vermithor/src/main/scala/core/fetch.scala
### file%3A%2F%2F%2Fhome%2Fshehroz%2FDesktop%2FNew%2520Folder%25203%2FVermithor%2Fsrc%2Fmain%2Fscala%2Fcore%2Ffetch.scala:49: error: `identifier` expected but `.` found
    io.Imem_fetch_out := inmmod.io.out 
      ^

occurred in the presentation compiler.

presentation compiler configuration:
Scala version: 2.12.19
Classpath:
<HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/scala-lang/scala-library/2.12.19/scala-library-2.12.19.jar [exists ]
Options:



action parameters:
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
    val Imem_fetch_enable  = Input(Bool()) // check
    val Imem_fetch_address = Input(UInt(32.W))
    val Imem_fetch_out = Output(UInt(32.W))


    // pc + imm
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
   when(io.Imem_fetch_out(6, 0) === 99.U || io.Imem_fetch_out(6,0) === "h6f".U) { // branch
        pcmod.io.jump := true.B
    }

    
    // connections between pc and fetch_module outputs
    io.pc_fetch_out := pcmod.io.out 


     // connections between instruction and fetch_module inputs
    inmmod.io.enable := io.Imem_fetch_enable
    inmmod.io.address := [cmod.io.out
    io.Imem_fetch_out := inmmod.io.out 

    
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
	scala.meta.internal.parsers.ScalametaParser.syntaxErrorExpected(ScalametaParser.scala:394)
	scala.meta.internal.parsers.ScalametaParser.syntaxErrorExpected(ScalametaParser.scala:392)
	scala.meta.internal.parsers.ScalametaParser.name(ScalametaParser.scala:1138)
	scala.meta.internal.parsers.ScalametaParser.termName(ScalametaParser.scala:1141)
	scala.meta.internal.parsers.ScalametaParser.path(ScalametaParser.scala:1188)
	scala.meta.internal.parsers.ScalametaParser$PatternContextSensitive.pathSimpleType$1(ScalametaParser.scala:972)
	scala.meta.internal.parsers.ScalametaParser$PatternContextSensitive.simpleType(ScalametaParser.scala:1020)
	scala.meta.internal.parsers.ScalametaParser$PatternContextSensitive.simpleType$(ScalametaParser.scala:963)
	scala.meta.internal.parsers.ScalametaParser$outPattern$.simpleType(ScalametaParser.scala:2714)
	scala.meta.internal.parsers.ScalametaParser$PatternContextSensitive.annotType(ScalametaParser.scala:956)
	scala.meta.internal.parsers.ScalametaParser$PatternContextSensitive.$anonfun$compoundType$1(ScalametaParser.scala:931)
	scala.Option.getOrElse(Option.scala:189)
	scala.meta.internal.parsers.ScalametaParser$PatternContextSensitive.compoundType(ScalametaParser.scala:929)
	scala.meta.internal.parsers.ScalametaParser$PatternContextSensitive.compoundType$(ScalametaParser.scala:929)
	scala.meta.internal.parsers.ScalametaParser$outPattern$.compoundType(ScalametaParser.scala:2714)
	scala.meta.internal.parsers.ScalametaParser$PatternContextSensitive.scala$meta$internal$parsers$ScalametaParser$PatternContextSensitive$$infixTypeRestWithMode(ScalametaParser.scala:893)
	scala.meta.internal.parsers.ScalametaParser$PatternContextSensitive.scala$meta$internal$parsers$ScalametaParser$PatternContextSensitive$$infixTypeRest(ScalametaParser.scala:873)
	scala.meta.internal.parsers.ScalametaParser$PatternContextSensitive.infixType(ScalametaParser.scala:862)
	scala.meta.internal.parsers.ScalametaParser$PatternContextSensitive.infixType$(ScalametaParser.scala:861)
	scala.meta.internal.parsers.ScalametaParser$outPattern$.infixType(ScalametaParser.scala:2714)
	scala.meta.internal.parsers.ScalametaParser$PatternContextSensitive.infixTypeOrTuple(ScalametaParser.scala:858)
	scala.meta.internal.parsers.ScalametaParser$PatternContextSensitive.infixTypeOrTuple$(ScalametaParser.scala:856)
	scala.meta.internal.parsers.ScalametaParser$outPattern$.infixTypeOrTuple(ScalametaParser.scala:2714)
	scala.meta.internal.parsers.ScalametaParser$PatternContextSensitive.$anonfun$typ$1(ScalametaParser.scala:789)
	scala.meta.internal.parsers.ScalametaParser.atPosOpt(ScalametaParser.scala:327)
	scala.meta.internal.parsers.ScalametaParser.autoPosOpt(ScalametaParser.scala:370)
	scala.meta.internal.parsers.ScalametaParser$PatternContextSensitive.typ(ScalametaParser.scala:785)
	scala.meta.internal.parsers.ScalametaParser$PatternContextSensitive.typ$(ScalametaParser.scala:785)
	scala.meta.internal.parsers.ScalametaParser$outPattern$.typ(ScalametaParser.scala:2714)
	scala.meta.internal.parsers.ScalametaParser$PatternContextSensitive.$anonfun$types$1(ScalametaParser.scala:1035)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$commaSeparated$1(ScalametaParser.scala:639)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$commaSeparated$1$adapted(ScalametaParser.scala:639)
	scala.meta.internal.parsers.ScalametaParser.iter$1(ScalametaParser.scala:629)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$tokenSeparated$1(ScalametaParser.scala:634)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$tokenSeparated$1$adapted(ScalametaParser.scala:622)
	scala.meta.internal.parsers.ScalametaParser.scala$meta$internal$parsers$ScalametaParser$$listBy(ScalametaParser.scala:562)
	scala.meta.internal.parsers.ScalametaParser.tokenSeparated(ScalametaParser.scala:622)
	scala.meta.internal.parsers.ScalametaParser.commaSeparatedWithIndex(ScalametaParser.scala:643)
	scala.meta.internal.parsers.ScalametaParser.commaSeparated(ScalametaParser.scala:639)
	scala.meta.internal.parsers.ScalametaParser$PatternContextSensitive.types(ScalametaParser.scala:1035)
	scala.meta.internal.parsers.ScalametaParser$PatternContextSensitive.types$(ScalametaParser.scala:1035)
	scala.meta.internal.parsers.ScalametaParser$outPattern$.types(ScalametaParser.scala:2714)
	scala.meta.internal.parsers.ScalametaParser$PatternContextSensitive.$anonfun$typeArgs$3(ScalametaParser.scala:854)
	scala.meta.internal.parsers.ScalametaParser.inBrackets(ScalametaParser.scala:297)
	scala.meta.internal.parsers.ScalametaParser$PatternContextSensitive.$anonfun$typeArgs$2(ScalametaParser.scala:854)
	scala.meta.internal.parsers.ScalametaParser.atPos(ScalametaParser.scala:325)
	scala.meta.internal.parsers.ScalametaParser.autoPos(ScalametaParser.scala:369)
	scala.meta.internal.parsers.ScalametaParser$PatternContextSensitive.$anonfun$typeArgs$1(ScalametaParser.scala:854)
	scala.meta.internal.parsers.NestedContext.within(NestedContext.scala:8)
	scala.meta.internal.parsers.NestedContext.within$(NestedContext.scala:6)
	scala.meta.internal.parsers.ScalametaParser$TypeBracketsContext$.within(ScalametaParser.scala:42)
	scala.meta.internal.parsers.ScalametaParser$PatternContextSensitive.typeArgs(ScalametaParser.scala:854)
	scala.meta.internal.parsers.ScalametaParser$PatternContextSensitive.typeArgs$(ScalametaParser.scala:853)
	scala.meta.internal.parsers.ScalametaParser$outPattern$.typeArgs(ScalametaParser.scala:2714)
	scala.meta.internal.parsers.ScalametaParser.exprTypeArgs(ScalametaParser.scala:2737)
	scala.meta.internal.parsers.ScalametaParser.getPostfixOrNextRhs$1(ScalametaParser.scala:1970)
	scala.meta.internal.parsers.ScalametaParser.loop$6(ScalametaParser.scala:1999)
	scala.meta.internal.parsers.ScalametaParser.postfixExpr(ScalametaParser.scala:2023)
	scala.meta.internal.parsers.ScalametaParser.postfixExpr(ScalametaParser.scala:1926)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$expr$2(ScalametaParser.scala:1552)
	scala.meta.internal.parsers.ScalametaParser.atPosOpt(ScalametaParser.scala:327)
	scala.meta.internal.parsers.ScalametaParser.autoPosOpt(ScalametaParser.scala:370)
	scala.meta.internal.parsers.ScalametaParser.expr(ScalametaParser.scala:1480)
	scala.meta.internal.parsers.ScalametaParser$$anonfun$templateStat$1.applyOrElse(ScalametaParser.scala:4154)
	scala.meta.internal.parsers.ScalametaParser$$anonfun$templateStat$1.applyOrElse(ScalametaParser.scala:4147)
	scala.PartialFunction.$anonfun$runWith$1$adapted(PartialFunction.scala:145)
	scala.meta.internal.parsers.ScalametaParser.statSeqBuf(ScalametaParser.scala:4107)
	scala.meta.internal.parsers.ScalametaParser.getStats$2(ScalametaParser.scala:4137)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$scala$meta$internal$parsers$ScalametaParser$$templateStatSeq$3(ScalametaParser.scala:4138)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$scala$meta$internal$parsers$ScalametaParser$$templateStatSeq$3$adapted(ScalametaParser.scala:4136)
	scala.meta.internal.parsers.ScalametaParser.scala$meta$internal$parsers$ScalametaParser$$listBy(ScalametaParser.scala:562)
	scala.meta.internal.parsers.ScalametaParser.scala$meta$internal$parsers$ScalametaParser$$templateStatSeq(ScalametaParser.scala:4136)
	scala.meta.internal.parsers.ScalametaParser.scala$meta$internal$parsers$ScalametaParser$$templateStatSeq(ScalametaParser.scala:4128)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$templateBody$1(ScalametaParser.scala:4006)
	scala.meta.internal.parsers.ScalametaParser.inBracesOr(ScalametaParser.scala:260)
	scala.meta.internal.parsers.ScalametaParser.inBraces(ScalametaParser.scala:256)
	scala.meta.internal.parsers.ScalametaParser.templateBody(ScalametaParser.scala:4006)
	scala.meta.internal.parsers.ScalametaParser.templateBodyOpt(ScalametaParser.scala:4009)
	scala.meta.internal.parsers.ScalametaParser.templateAfterExtends(ScalametaParser.scala:3960)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$template$1(ScalametaParser.scala:3976)
	scala.meta.internal.parsers.ScalametaParser.atPos(ScalametaParser.scala:325)
	scala.meta.internal.parsers.ScalametaParser.autoPos(ScalametaParser.scala:369)
	scala.meta.internal.parsers.ScalametaParser.template(ScalametaParser.scala:3965)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$templateOpt$1(ScalametaParser.scala:4000)
	scala.meta.internal.parsers.ScalametaParser.atPos(ScalametaParser.scala:325)
	scala.meta.internal.parsers.ScalametaParser.autoPos(ScalametaParser.scala:369)
	scala.meta.internal.parsers.ScalametaParser.templateOpt(ScalametaParser.scala:3993)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$classDef$1(ScalametaParser.scala:3657)
	scala.meta.internal.parsers.ScalametaParser.autoEndPos(ScalametaParser.scala:372)
	scala.meta.internal.parsers.ScalametaParser.autoEndPos(ScalametaParser.scala:377)
	scala.meta.internal.parsers.ScalametaParser.classDef(ScalametaParser.scala:3635)
	scala.meta.internal.parsers.ScalametaParser.tmplDef(ScalametaParser.scala:3599)
	scala.meta.internal.parsers.ScalametaParser.topLevelTmplDef(ScalametaParser.scala:3589)
	scala.meta.internal.parsers.ScalametaParser$$anonfun$2.applyOrElse(ScalametaParser.scala:4121)
	scala.meta.internal.parsers.ScalametaParser$$anonfun$2.applyOrElse(ScalametaParser.scala:4115)
	scala.PartialFunction.$anonfun$runWith$1$adapted(PartialFunction.scala:145)
	scala.meta.internal.parsers.ScalametaParser.statSeqBuf(ScalametaParser.scala:4107)
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

file%3A%2F%2F%2Fhome%2Fshehroz%2FDesktop%2FNew%2520Folder%25203%2FVermithor%2Fsrc%2Fmain%2Fscala%2Fcore%2Ffetch.scala:49: error: `identifier` expected but `.` found
    io.Imem_fetch_out := inmmod.io.out 
      ^