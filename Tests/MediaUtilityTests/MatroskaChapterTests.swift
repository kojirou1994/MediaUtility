import XCTest
import MediaTools
import MediaUtility

final class MatroskaChapterTests: XCTestCase {

  func testDecode() throws {
    try examples.forEach { example in
      let decoded = try MatroskaChapter(data: Data(example.utf8))
      dump(decoded)
      let encoded = try decoded.exportXML().utf8String
      print(encoded)

      XCTAssertEqual(decoded, try MatroskaChapter(data: Data(encoded.utf8)))
    }
  }

  func testFillUIDs() {
    var chapter = MatroskaChapter(entries: [.init(chapters: [.init(startTime: Timestamp.zero), .init(startTime: Timestamp.hour)])])
    print(chapter)
    chapter.fillUIDs()
    print(chapter)

    var uids = Set<UInt>()
    chapter.entries.forEach { entry in
      XCTAssertTrue(uids.insert(entry.uid).inserted)
      entry.chapters.forEach { chapter in
        XCTAssertTrue(uids.insert(chapter.uid).inserted)
      }
    }
  }
}

fileprivate let examples = [
  """
<Chapters>
  <EditionEntry>
    <EditionUID>16603393396715046047</EditionUID>
    <ChapterAtom>
      <ChapterUID>1193046</ChapterUID>
      <ChapterTimeStart>0</ChapterTimeStart>
      <ChapterTimeEnd>5000000000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapString>Intro</ChapString>
        <ChapLanguage>eng</ChapLanguage>
      </ChapterDisplay>
      <ChapterFlagHidden>0</ChapterFlagHidden>
      <ChapterFlagEnabled>1</ChapterFlagEnabled>
    </ChapterAtom>
    <ChapterAtom>
      <ChapterUID>2311527</ChapterUID>
      <ChapterTimeStart>5000000000</ChapterTimeStart>
      <ChapterTimeEnd>25000000000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapString>Before the crime</ChapString>
        <ChapLanguage>eng</ChapLanguage>
      </ChapterDisplay>
      <ChapterDisplay>
        <ChapString>Avant le crime</ChapString>
        <ChapLanguage>fra</ChapLanguage>
      </ChapterDisplay>
      <ChapterFlagHidden>0</ChapterFlagHidden>
      <ChapterFlagEnabled>1</ChapterFlagEnabled>
    </ChapterAtom>
    <ChapterAtom>
      <ChapterUID>3430008</ChapterUID>
      <ChapterTimeStart>25000000000</ChapterTimeStart>
      <ChapterTimeEnd>27500000000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapString>The crime</ChapString>
        <ChapLanguage>eng</ChapLanguage>
      </ChapterDisplay>
      <ChapterDisplay>
        <ChapString>Le crime</ChapString>
        <ChapLanguage>fra</ChapLanguage>
      </ChapterDisplay>
      <ChapterFlagHidden>0</ChapterFlagHidden>
      <ChapterFlagEnabled>1</ChapterFlagEnabled>
    </ChapterAtom>
    <ChapterAtom>
      <ChapterUID>4548489</ChapterUID>
      <ChapterTimeStart>27500000000</ChapterTimeStart>
      <ChapterTimeEnd>38000000000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapString>After the crime</ChapString>
        <ChapLanguage>eng</ChapLanguage>
      </ChapterDisplay>
      <ChapterDisplay>
        <ChapString>Après le crime</ChapString>
        <ChapLanguage>fra</ChapLanguage>
      </ChapterDisplay>
      <ChapterFlagHidden>0</ChapterFlagHidden>
      <ChapterFlagEnabled>1</ChapterFlagEnabled>
    </ChapterAtom>
    <ChapterAtom>
      <ChapterUID>5666960</ChapterUID>
      <ChapterTimeStart>38000000000</ChapterTimeStart>
      <ChapterTimeEnd>43000000000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapString>Credits</ChapString>
        <ChapLanguage>eng</ChapLanguage>
      </ChapterDisplay>
      <ChapterDisplay>
        <ChapString>Générique</ChapString>
        <ChapLanguage>fra</ChapLanguage>
      </ChapterDisplay>
      <ChapterFlagHidden>0</ChapterFlagHidden>
      <ChapterFlagEnabled>1</ChapterFlagEnabled>
    </ChapterAtom>
    <EditionFlagDefault>0</EditionFlagDefault>
    <EditionFlagHidden>0</EditionFlagHidden>
  </EditionEntry>
</Chapters>
""",
  """
<Chapters>
  <EditionEntry>
    <EditionUID>1281690858003401414</EditionUID>
    <ChapterAtom>
      <ChapterUID>1</ChapterUID>
      <ChapterTimeStart>0</ChapterTimeStart>
      <ChapterTimeEnd>748000000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapString>Baby wants to Bleep/Rock</ChapString>
        <ChapLanguage>eng</ChapLanguage>
      </ChapterDisplay>
      <ChapterAtom>
        <ChapterUID>2</ChapterUID>
        <ChapterTimeStart>0</ChapterTimeStart>
        <ChapterTimeEnd>278000000</ChapterTimeEnd>
        <ChapterDisplay>
          <ChapString>Baby wants to bleep (pt.1)</ChapString>
          <ChapLanguage>eng</ChapLanguage>
        </ChapterDisplay>
        <ChapterFlagHidden>0</ChapterFlagHidden>
        <ChapterFlagEnabled>1</ChapterFlagEnabled>
      </ChapterAtom>
      <ChapterAtom>
        <ChapterUID>3</ChapterUID>
        <ChapterTimeStart>278000000</ChapterTimeStart>
        <ChapterTimeEnd>432000000</ChapterTimeEnd>
        <ChapterDisplay>
          <ChapString>Baby wants to rock</ChapString>
          <ChapLanguage>eng</ChapLanguage>
        </ChapterDisplay>
        <ChapterFlagHidden>0</ChapterFlagHidden>
        <ChapterFlagEnabled>1</ChapterFlagEnabled>
      </ChapterAtom>
      <ChapterAtom>
        <ChapterUID>4</ChapterUID>
        <ChapterTimeStart>432000000</ChapterTimeStart>
        <ChapterTimeEnd>633000000</ChapterTimeEnd>
        <ChapterDisplay>
          <ChapString>Baby wants to bleep (pt.2)</ChapString>
          <ChapLanguage>eng</ChapLanguage>
        </ChapterDisplay>
        <ChapterFlagHidden>0</ChapterFlagHidden>
        <ChapterFlagEnabled>1</ChapterFlagEnabled>
      </ChapterAtom>
      <ChapterAtom>
        <ChapterUID>5</ChapterUID>
        <ChapterTimeStart>633000000</ChapterTimeStart>
        <ChapterTimeEnd>748000000</ChapterTimeEnd>
        <ChapterDisplay>
          <ChapString>Baby wants to bleep (pt.3)</ChapString>
          <ChapLanguage>eng</ChapLanguage>
        </ChapterDisplay>
        <ChapterFlagHidden>0</ChapterFlagHidden>
        <ChapterFlagEnabled>1</ChapterFlagEnabled>
      </ChapterAtom>
      <ChapterFlagHidden>0</ChapterFlagHidden>
      <ChapterFlagEnabled>1</ChapterFlagEnabled>
    </ChapterAtom>
    <ChapterAtom>
      <ChapterUID>6</ChapterUID>
      <ChapterTimeStart>750000000</ChapterTimeStart>
      <ChapterTimeEnd>1178500000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapString>Bleeper_O+2</ChapString>
        <ChapLanguage>eng</ChapLanguage>
      </ChapterDisplay>
      <ChapterFlagHidden>0</ChapterFlagHidden>
      <ChapterFlagEnabled>1</ChapterFlagEnabled>
    </ChapterAtom>
    <ChapterAtom>
      <ChapterUID>7</ChapterUID>
      <ChapterTimeStart>1180500000</ChapterTimeStart>
      <ChapterTimeEnd>1340000000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapString>Baby wants to bleep (pt.4)</ChapString>
        <ChapLanguage>eng</ChapLanguage>
      </ChapterDisplay>
      <ChapterFlagHidden>0</ChapterFlagHidden>
      <ChapterFlagEnabled>1</ChapterFlagEnabled>
    </ChapterAtom>
    <ChapterAtom>
      <ChapterUID>8</ChapterUID>
      <ChapterTimeStart>1342000000</ChapterTimeStart>
      <ChapterTimeEnd>1518000000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapString>Bleep to bleep</ChapString>
        <ChapLanguage>eng</ChapLanguage>
      </ChapterDisplay>
      <ChapterFlagHidden>0</ChapterFlagHidden>
      <ChapterFlagEnabled>1</ChapterFlagEnabled>
    </ChapterAtom>
    <ChapterAtom>
      <ChapterUID>9</ChapterUID>
      <ChapterTimeStart>1520000000</ChapterTimeStart>
      <ChapterTimeEnd>2015000000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapString>Baby wants to bleep (k)</ChapString>
        <ChapLanguage>eng</ChapLanguage>
      </ChapterDisplay>
      <ChapterFlagHidden>0</ChapterFlagHidden>
      <ChapterFlagEnabled>1</ChapterFlagEnabled>
    </ChapterAtom>
    <ChapterAtom>
      <ChapterUID>10</ChapterUID>
      <ChapterTimeStart>2017000000</ChapterTimeStart>
      <ChapterTimeEnd>2668000000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapString>Bleeper</ChapString>
        <ChapLanguage>eng</ChapLanguage>
      </ChapterDisplay>
      <ChapterFlagHidden>0</ChapterFlagHidden>
      <ChapterFlagEnabled>1</ChapterFlagEnabled>
    </ChapterAtom>
    <EditionFlagDefault>0</EditionFlagDefault>
    <EditionFlagHidden>0</EditionFlagHidden>
  </EditionEntry>
</Chapters>
"""
]
