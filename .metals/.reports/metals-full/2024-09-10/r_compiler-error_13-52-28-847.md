file://<HOME>/Desktop/New%20Folder%203/Vermithor/src/main/scala/core/decode.scala
### java.lang.ArrayIndexOutOfBoundsException: Index 3 out of bounds for length 3

occurred in the presentation compiler.

presentation compiler configuration:
Scala version: 2.12.19
Classpath:
<HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/scala-lang/scala-library/2.12.19/scala-library-2.12.19.jar [exists ]
Options:



action parameters:
offset: 0
uri: file://<HOME>/Desktop/New%20Folder%203/Vermithor/src/main/scala/core/decode.scala
text:
```scala
@@
```



#### Error stacktrace:

```
scala.reflect.internal.util.BatchSourceFile.findLine$1(SourceFile.scala:201)
	scala.reflect.internal.util.BatchSourceFile.offsetToLine(SourceFile.scala:204)
	scala.meta.internal.pc.MetalsGlobal$XtensionPositionMetals.toPos(MetalsGlobal.scala:727)
	scala.meta.internal.pc.MetalsGlobal$XtensionPositionMetals.toLsp(MetalsGlobal.scala:740)
	scala.meta.internal.pc.PcDocumentHighlightProvider.collect(PcDocumentHighlightProvider.scala:21)
	scala.meta.internal.pc.PcDocumentHighlightProvider.collect(PcDocumentHighlightProvider.scala:9)
	scala.meta.internal.pc.PcCollector.scala$meta$internal$pc$PcCollector$$collect$1(PcCollector.scala:108)
	scala.meta.internal.pc.PcCollector.traverseWithParent$1(PcCollector.scala:177)
	scala.meta.internal.pc.PcCollector.traverseSought(PcCollector.scala:314)
	scala.meta.internal.pc.PcCollector.traverseSought$(PcCollector.scala:95)
	scala.meta.internal.pc.WithSymbolSearchCollector.traverseSought(PcCollector.scala:345)
	scala.meta.internal.pc.PcCollector.resultWithSought(PcCollector.scala:82)
	scala.meta.internal.pc.PcCollector.resultWithSought$(PcCollector.scala:17)
	scala.meta.internal.pc.WithSymbolSearchCollector.resultWithSought(PcCollector.scala:345)
	scala.meta.internal.pc.WithSymbolSearchCollector.$anonfun$result$1(PcCollector.scala:352)
	scala.Option.map(Option.scala:230)
	scala.meta.internal.pc.WithSymbolSearchCollector.result(PcCollector.scala:352)
	scala.meta.internal.pc.PcDocumentHighlightProvider.highlights(PcDocumentHighlightProvider.scala:30)
	scala.meta.internal.pc.ScalaPresentationCompiler.$anonfun$documentHighlight$1(ScalaPresentationCompiler.scala:432)
```
#### Short summary: 

java.lang.ArrayIndexOutOfBoundsException: Index 3 out of bounds for length 3