file://<HOME>/Desktop/New%20Folder%203/Vermithor/src/test/scala/core/fetchtest.scala
### file%3A%2F%2F%2Fhome%2Fshehroz%2FDesktop%2FNew%2520Folder%25203%2FVermithor%2Fsrc%2Ftest%2Fscala%2Fcore%2Ffetchtest.scala:15: error: `identifier` expected but `.` found
     a.io..poke(1.U) 
          ^

occurred in the presentation compiler.

presentation compiler configuration:
Scala version: 2.12.19
Classpath:
<HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/scala-lang/scala-library/2.12.19/scala-library-2.12.19.jar [exists ]
Options:



action parameters:
uri: file://<HOME>/Desktop/New%20Folder%203/Vermithor/src/test/scala/core/fetchtest.scala
text:
```scala
package core
import chisel3._
import chisel3.tester._
import org.scalatest.FreeSpec
import chisel3.experimental.BundleLiterals._
class fetchtest extends FreeSpec with ChiselScalatestTester{
"Chisel Tester fetch test" in {
    test(new alu){  a=>
    a.io.pc_fetch_imm.poke(2.U)  
    a.io.pc_fetch_jump.poke(0.U)
    a.io.pc_fetch_jump2.poke(0.U) 
    a.io.pc_fetch_jump3.poke(0.U)  


     a.io..poke(1.U) 



    a.clock.step(2)


    a.io.out.expect(2.U)
    
    }

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
	scala.meta.internal.parsers.ScalametaParser.syntaxErrorExpected(ScalametaParser.scala:394)
	scala.meta.internal.parsers.ScalametaParser.syntaxErrorExpected(ScalametaParser.scala:392)
	scala.meta.internal.parsers.ScalametaParser.name(ScalametaParser.scala:1138)
	scala.meta.internal.parsers.ScalametaParser.termName(ScalametaParser.scala:1141)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$selector$1(ScalametaParser.scala:1197)
	scala.meta.internal.parsers.ScalametaParser.autoEndPos(ScalametaParser.scala:372)
	scala.meta.internal.parsers.ScalametaParser.selector(ScalametaParser.scala:1197)
	scala.meta.internal.parsers.ScalametaParser.simpleExprRest(ScalametaParser.scala:2149)
	scala.meta.internal.parsers.ScalametaParser.simpleExpr0(ScalametaParser.scala:2094)
	scala.meta.internal.parsers.ScalametaParser.simpleExpr(ScalametaParser.scala:2061)
	scala.meta.internal.parsers.ScalametaParser.prefixExpr(ScalametaParser.scala:2058)
	scala.meta.internal.parsers.ScalametaParser.postfixExpr(ScalametaParser.scala:1924)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$expr$2(ScalametaParser.scala:1552)
	scala.meta.internal.parsers.ScalametaParser.atPosOpt(ScalametaParser.scala:327)
	scala.meta.internal.parsers.ScalametaParser.autoPosOpt(ScalametaParser.scala:370)
	scala.meta.internal.parsers.ScalametaParser.expr(ScalametaParser.scala:1480)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$blockStatSeq$3(ScalametaParser.scala:4234)
	scala.meta.internal.parsers.ScalametaParser.stat(ScalametaParser.scala:4091)
	scala.meta.internal.parsers.ScalametaParser.iter$7(ScalametaParser.scala:4234)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$blockStatSeq$1(ScalametaParser.scala:4247)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$blockStatSeq$1$adapted(ScalametaParser.scala:4197)
	scala.meta.internal.parsers.ScalametaParser.scala$meta$internal$parsers$ScalametaParser$$listBy(ScalametaParser.scala:562)
	scala.meta.internal.parsers.ScalametaParser.blockStatSeq(ScalametaParser.scala:4197)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$blockOnOther$1(ScalametaParser.scala:2392)
	scala.meta.internal.parsers.ScalametaParser.atPosOpt(ScalametaParser.scala:327)
	scala.meta.internal.parsers.ScalametaParser.autoPosOpt(ScalametaParser.scala:370)
	scala.meta.internal.parsers.ScalametaParser.blockOnOther(ScalametaParser.scala:2392)
	scala.meta.internal.parsers.ScalametaParser.termFunctionBody(ScalametaParser.scala:1651)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$exprOtherRest$7(ScalametaParser.scala:1635)
	scala.Option.fold(Option.scala:251)
	scala.meta.internal.parsers.ScalametaParser.exprOtherRest(ScalametaParser.scala:1632)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$expr$2(ScalametaParser.scala:1553)
	scala.meta.internal.parsers.ScalametaParser.atPosOpt(ScalametaParser.scala:327)
	scala.meta.internal.parsers.ScalametaParser.autoPosOpt(ScalametaParser.scala:370)
	scala.meta.internal.parsers.ScalametaParser.expr(ScalametaParser.scala:1480)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$blockStatSeq$3(ScalametaParser.scala:4234)
	scala.meta.internal.parsers.ScalametaParser.stat(ScalametaParser.scala:4091)
	scala.meta.internal.parsers.ScalametaParser.iter$7(ScalametaParser.scala:4234)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$blockStatSeq$1(ScalametaParser.scala:4247)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$blockStatSeq$1$adapted(ScalametaParser.scala:4197)
	scala.meta.internal.parsers.ScalametaParser.scala$meta$internal$parsers$ScalametaParser$$listBy(ScalametaParser.scala:562)
	scala.meta.internal.parsers.ScalametaParser.blockStatSeq(ScalametaParser.scala:4197)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$blockOnBrace$2(ScalametaParser.scala:2385)
	scala.meta.internal.parsers.ScalametaParser.inBracesOnOpen(ScalametaParser.scala:265)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$blockOnBrace$1(ScalametaParser.scala:2383)
	scala.meta.internal.parsers.ScalametaParser.atPos(ScalametaParser.scala:325)
	scala.meta.internal.parsers.ScalametaParser.autoPos(ScalametaParser.scala:369)
	scala.meta.internal.parsers.ScalametaParser.blockOnBrace(ScalametaParser.scala:2383)
	scala.meta.internal.parsers.ScalametaParser.blockOnBrace(ScalametaParser.scala:2385)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$blockExprOnBrace$1(ScalametaParser.scala:2388)
	scala.meta.internal.parsers.ScalametaParser.blockExprPartial(ScalametaParser.scala:2367)
	scala.meta.internal.parsers.ScalametaParser.blockExprOnBrace(ScalametaParser.scala:2387)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$getArgClauseOnBrace$1(ScalametaParser.scala:2320)
	scala.meta.internal.parsers.ScalametaParser.atPos(ScalametaParser.scala:325)
	scala.meta.internal.parsers.ScalametaParser.autoPos(ScalametaParser.scala:369)
	scala.meta.internal.parsers.ScalametaParser.getArgClauseOnBrace(ScalametaParser.scala:2319)
	scala.meta.internal.parsers.ScalametaParser.argClause$1(ScalametaParser.scala:2165)
	scala.meta.internal.parsers.ScalametaParser.simpleExprRest(ScalametaParser.scala:2166)
	scala.meta.internal.parsers.ScalametaParser.simpleExpr0(ScalametaParser.scala:2094)
	scala.meta.internal.parsers.ScalametaParser.simpleExpr(ScalametaParser.scala:2061)
	scala.meta.internal.parsers.ScalametaParser.prefixExpr(ScalametaParser.scala:2058)
	scala.meta.internal.parsers.ScalametaParser.postfixExpr(ScalametaParser.scala:1924)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$expr$2(ScalametaParser.scala:1552)
	scala.meta.internal.parsers.ScalametaParser.atPosOpt(ScalametaParser.scala:327)
	scala.meta.internal.parsers.ScalametaParser.autoPosOpt(ScalametaParser.scala:370)
	scala.meta.internal.parsers.ScalametaParser.expr(ScalametaParser.scala:1480)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$blockStatSeq$3(ScalametaParser.scala:4234)
	scala.meta.internal.parsers.ScalametaParser.stat(ScalametaParser.scala:4091)
	scala.meta.internal.parsers.ScalametaParser.iter$7(ScalametaParser.scala:4234)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$blockStatSeq$1(ScalametaParser.scala:4247)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$blockStatSeq$1$adapted(ScalametaParser.scala:4197)
	scala.meta.internal.parsers.ScalametaParser.scala$meta$internal$parsers$ScalametaParser$$listBy(ScalametaParser.scala:562)
	scala.meta.internal.parsers.ScalametaParser.blockStatSeq(ScalametaParser.scala:4197)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$blockOnBrace$2(ScalametaParser.scala:2385)
	scala.meta.internal.parsers.ScalametaParser.inBracesOnOpen(ScalametaParser.scala:265)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$blockOnBrace$1(ScalametaParser.scala:2383)
	scala.meta.internal.parsers.ScalametaParser.atPos(ScalametaParser.scala:325)
	scala.meta.internal.parsers.ScalametaParser.autoPos(ScalametaParser.scala:369)
	scala.meta.internal.parsers.ScalametaParser.blockOnBrace(ScalametaParser.scala:2383)
	scala.meta.internal.parsers.ScalametaParser.blockOnBrace(ScalametaParser.scala:2385)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$blockExprOnBrace$1(ScalametaParser.scala:2388)
	scala.meta.internal.parsers.ScalametaParser.blockExprPartial(ScalametaParser.scala:2367)
	scala.meta.internal.parsers.ScalametaParser.blockExprOnBrace(ScalametaParser.scala:2387)
	scala.meta.internal.parsers.ScalametaParser.argumentExprsOrPrefixExpr(ScalametaParser.scala:2294)
	scala.meta.internal.parsers.ScalametaParser.getNextRhs$2(ScalametaParser.scala:1945)
	scala.meta.internal.parsers.ScalametaParser.getPostfixOrNextRhs$1(ScalametaParser.scala:1979)
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

file%3A%2F%2F%2Fhome%2Fshehroz%2FDesktop%2FNew%2520Folder%25203%2FVermithor%2Fsrc%2Ftest%2Fscala%2Fcore%2Ffetchtest.scala:15: error: `identifier` expected but `.` found
     a.io..poke(1.U) 
          ^