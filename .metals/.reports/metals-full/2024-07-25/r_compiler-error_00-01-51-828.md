file://<HOME>/Desktop/piplining/5%20stage%20pipielining%20processorold/src/main/scala/pipeline/Imem.scala
### file%3A%2F%2F%2Fhome%2Fshehroz%2FDesktop%2Fpiplining%2F5%2520stage%2520pipielining%2520processorold%2Fsrc%2Fmain%2Fscala%2Fpipeline%2FImem.scala:16: error: unclosed string literal
loadMemoryFromFile(memory,"<HOME>/5 stage pipielining processor/src/main/scala/pipeline/inst_file.txt\")
                          ^

occurred in the presentation compiler.

presentation compiler configuration:
Scala version: 2.12.13
Classpath:
<HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/scala-lang/scala-library/2.12.13/scala-library-2.12.13.jar [exists ]
Options:



action parameters:
uri: file://<HOME>/Desktop/piplining/5%20stage%20pipielining%20processorold/src/main/scala/pipeline/Imem.scala
text:
```scala
package pipeline
import chisel3._
import chisel3.util._
// import chisel3.util.experimental.experimentalloadMemoryFromFile
import chisel3.util.experimental.loadMemoryFromFile
class Imem extends Module {
val io = IO (new Bundle {
  val data_in= Input(UInt(32.W))
 val enable = Input(Bool())
  val address= Input(UInt(32.W))
  val out= Output(UInt(32.W))
})
// val memory = Mem(256, UInt(32.W))
  val memory = SyncReadMem(256, UInt(32.W))

loadMemoryFromFile(memory,"<HOME>/5 stage pipielining processor/src/main/scala/pipeline/inst_file.txt\")

when ( io.enable ) {
memory.write( io.address >> 2 , io.data_in  )
}
io.out := memory.read( io.address >> 2)
}


```



#### Error stacktrace:

```
scala.meta.internal.tokenizers.Reporter.syntaxError(Reporter.scala:23)
	scala.meta.internal.tokenizers.Reporter.syntaxError$(Reporter.scala:23)
	scala.meta.internal.tokenizers.Reporter$$anon$1.syntaxError(Reporter.scala:33)
	scala.meta.internal.tokenizers.Reporter.syntaxError(Reporter.scala:25)
	scala.meta.internal.tokenizers.Reporter.syntaxError$(Reporter.scala:25)
	scala.meta.internal.tokenizers.Reporter$$anon$1.syntaxError(Reporter.scala:33)
	scala.meta.internal.tokenizers.LegacyScanner.getStringLit(LegacyScanner.scala:591)
	scala.meta.internal.tokenizers.LegacyScanner.fetchDoubleQuote$1(LegacyScanner.scala:407)
	scala.meta.internal.tokenizers.LegacyScanner.fetchToken(LegacyScanner.scala:411)
	scala.meta.internal.tokenizers.LegacyScanner.nextToken(LegacyScanner.scala:246)
	scala.meta.internal.tokenizers.LegacyScanner.foreach(LegacyScanner.scala:1047)
	scala.meta.internal.tokenizers.ScalametaTokenizer.uncachedTokenize(ScalametaTokenizer.scala:24)
	scala.meta.internal.tokenizers.ScalametaTokenizer.$anonfun$tokenize$1(ScalametaTokenizer.scala:17)
	scala.collection.concurrent.TrieMap.getOrElseUpdate(TrieMap.scala:895)
	scala.meta.internal.tokenizers.ScalametaTokenizer.tokenize(ScalametaTokenizer.scala:17)
	scala.meta.internal.tokenizers.ScalametaTokenizer$$anon$2.apply(ScalametaTokenizer.scala:332)
	scala.meta.tokenizers.Api$XtensionTokenizeDialectInput.tokenize(Api.scala:25)
	scala.meta.tokenizers.Api$XtensionTokenizeInputLike.tokenize(Api.scala:14)
	scala.meta.internal.parsers.ScannerTokens$.apply(ScannerTokens.scala:875)
	scala.meta.internal.parsers.ScalametaParser.<init>(ScalametaParser.scala:33)
	scala.meta.parsers.Parse$$anon$1.apply(Parse.scala:35)
	scala.meta.parsers.Api$XtensionParseDialectInput.parse(Api.scala:25)
	scala.meta.internal.semanticdb.scalac.ParseOps$XtensionCompilationUnitSource.toSource(ParseOps.scala:17)
	scala.meta.internal.semanticdb.scalac.TextDocumentOps$XtensionCompilationUnitDocument.toTextDocument(TextDocumentOps.scala:206)
	scala.meta.internal.pc.SemanticdbTextDocumentProvider.textDocument(SemanticdbTextDocumentProvider.scala:54)
	scala.meta.internal.pc.ScalaPresentationCompiler.$anonfun$semanticdbTextDocument$1(ScalaPresentationCompiler.scala:462)
```
#### Short summary: 

file%3A%2F%2F%2Fhome%2Fshehroz%2FDesktop%2Fpiplining%2F5%2520stage%2520pipielining%2520processorold%2Fsrc%2Fmain%2Fscala%2Fpipeline%2FImem.scala:16: error: unclosed string literal
loadMemoryFromFile(memory,"<HOME>/5 stage pipielining processor/src/main/scala/pipeline/inst_file.txt\")
                          ^