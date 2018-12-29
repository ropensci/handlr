# from https://github.com/datacite/bolognese/blob/master/lib/bolognese/utils.rb

LICENSE_NAMES <- list(
  "http://creativecommons.org/publicdomain/zero/1.0/" = 
    "Public Domain (CC0 1.0)",
  "http://creativecommons.org/licenses/by/3.0/" = 
    "Creative Commons Attribution 3.0 (CC-BY 3.0)",
  "http://creativecommons.org/licenses/by/4.0/" = 
    "Creative Commons Attribution 4.0 (CC-BY 4.0)",
  "http://creativecommons.org/licenses/by-nc/4.0/" = 
    "Creative Commons Attribution Noncommercial 4.0 (CC-BY-NC 4.0)",
  "http://creativecommons.org/licenses/by-sa/4.0/" = 
    "Creative Commons Attribution Share Alike 4.0 (CC-BY-SA 4.0)",
  "http://creativecommons.org/licenses/by-nc-nd/4.0/" = 
    "Creative Commons Attribution Noncommercial No Derivatives 4.0 (CC-BY-NC-ND 4.0)"
)

DC_TO_SO_TRANSLATIONS <- list(
  "Audiovisual" = "MediaObject",
  "Collection" = "Collection",
  "Dataset" = "Dataset",
  "Event" = "Event",
  "Image" = "ImageObject",
  "InteractiveResource" = NULL,
  "Model" = NULL,
  "PhysicalObject" = NULL,
  "Service" = "Service",
  "Software" = "SoftwareSourceCode",
  "Sound" = "AudioObject",
  "Text" = "ScholarlyArticle",
  "Workflow" = NULL,
  "Other" = "CreativeWork"
)

DC_TO_CP_TRANSLATIONS <- list(
  "Audiovisual" = "motion_picture",
  "Collection" = NULL,
  "Dataset" = "dataset",
  "Event" = NULL,
  "Image" = "graphic",
  "InteractiveResource" = NULL,
  "Model" = NULL,
  "PhysicalObject" = NULL,
  "Service" = NULL,
  "Sound" = "song",
  "Text" = "report",
  "Workflow" = NULL,
  "Other" = NULL
)

CR_TO_CP_TRANSLATIONS <- list(
  "Proceedings" = NULL,
  "ReferenceBook" = NULL,
  "JournalIssue" = NULL,
  "ProceedingsArticle" = "paper-conference",
  "Other" = NULL,
  "Dissertation" = "thesis",
  "Dataset" = "dataset",
  "EditedBook" = "book",
  "JournalArticle" = "article-journal",
  "Journal" = NULL,
  "Report" = "report",
  "BookSeries" = NULL,
  "ReportSeries" = NULL,
  "BookTrack" = NULL,
  "Standard" = NULL,
  "BookSection" = "chapter",
  "BookPart" = NULL,
  "Book" = "book",
  "BookChapter" = "chapter",
  "StandardSeries" = NULL,
  "Monograph" = "book",
  "Component" = NULL,
  "ReferenceEntry" = "entry-dictionary",
  "JournalVolume" = NULL,
  "BookSet" = NULL
)

CR_TO_SO_TRANSLATIONS <- list(
  "Proceedings" = NULL,
  "ReferenceBook" = "Book",
  "JournalIssue" = "PublicationIssue",
  "ProceedingsArticle" = NULL,
  "Other" = "CreativeWork",
  "Dissertation" = "Thesis",
  "Dataset" = "Dataset",
  "EditedBook" = "Book",
  "JournalArticle" = "ScholarlyArticle",
  "Journal" = NULL,
  "Report" = NULL,
  "BookSeries" = NULL,
  "ReportSeries" = NULL,
  "BookTrack" = NULL,
  "Standard" = NULL,
  "BookSection" = NULL,
  "BookPart" = NULL,
  "Book" = "Book",
  "BookChapter" = "Chapter",
  "StandardSeries" = NULL,
  "Monograph" = "Book",
  "Component" = "CreativeWork",
  "ReferenceEntry" = NULL,
  "JournalVolume" = "PublicationVolume",
  "BookSet" = NULL,
  "PostedContent" = "ScholarlyArticle"
)

CR_TO_BIB_TRANSLATIONS <- list(
  "Proceedings" = "proceedings",
  "ReferenceBook" = "book",
  "JournalIssue" = NULL,
  "ProceedingsArticle" = NULL,
  "Other" = NULL,
  "Dissertation" = "phdthesis",
  "Dataset" = NULL,
  "EditedBook" = "book",
  "JournalArticle" = "article",
  "Journal" = NULL,
  "Report" = NULL,
  "BookSeries" = NULL,
  "ReportSeries" = NULL,
  "BookTrack" = NULL,
  "Standard" = NULL,
  "BookSection" = "inbook",
  "BookPart" = NULL,
  "Book" = "book",
  "BookChapter" = "inbook",
  "StandardSeries" = NULL,
  "Monograph" = "book",
  "Component" = NULL,
  "ReferenceEntry" = NULL,
  "JournalVolume" = NULL,
  "BookSet" = NULL,
  "PostedContent" = "article"
)

BIB_TO_CR_TRANSLATIONS <- list(
  "proceedings" = "Proceedings",
  "phdthesis" = "Dissertation",
  "article" = "JournalArticle",
  "book" = "Book",
  "inbook" = "BookChapter"
)

CR_TO_JATS_TRANSLATIONS <- list(
  "Proceedings" = "working-paper",
  "ReferenceBook" = "book",
  "JournalIssue" = "journal",
  "ProceedingsArticle" = "working-paper",
  "Other" = NULL,
  "Dissertation" = NULL,
  "Dataset" = "data",
  "EditedBook" = "book",
  "JournalArticle" = "journal",
  "Journal" = "journal",
  "Report" = "report",
  "BookSeries" = "book",
  "ReportSeries" = "report",
  "BookTrack" = "book",
  "Standard" = "standard",
  "BookSection" = "chapter",
  "BookPart" = "chapter",
  "Book" = "book",
  "BookChapter" = "chapter",
  "StandardSeries" = "standard",
  "Monograph" = "book",
  "Component" = NULL,
  "ReferenceEntry" = NULL,
  "JournalVolume" = "journal",
  "BookSet" = "book"
)

SO_TO_DC_TRANSLATIONS <- list(
  "Article" = "Text",
  "AudioObject" = "Sound",
  "Blog" = "Text",
  "BlogPosting" = "Text",
  "Chapter" = "Text",
  "Collection" = "Collection",
  "CreativeWork" = "Other",
  "DataCatalog" = "Dataset",
  "Dataset" = "Dataset",
  "Event" = "Event",
  "ImageObject" = "Image",
  "Movie" = "Audiovisual",
  "PublicationIssue" = "Text",
  "ScholarlyArticle" = "Text",
  "Thesis" = "Text",
  "Service" = "Service",
  "SoftwareSourceCode" = "Software",
  "VideoObject" = "Audiovisual",
  "WebPage" = "Text",
  "WebSite" = "Text"
)

SO_TO_JATS_TRANSLATIONS <- list(
  "Article" = "journal",
  "AudioObject" = NULL,
  "Blog" = NULL,
  "BlogPosting" = NULL,
  "Book" = "book",
  "Collection" = NULL,
  "CreativeWork" = NULL,
  "DataCatalog" = "data",
  "Dataset" = "data",
  "Event" = NULL,
  "ImageObject" = NULL,
  "Movie" = NULL,
  "PublicationIssue" = "journal",
  "ScholarlyArticle" = "journal",
  "Service" = NULL,
  "SoftwareSourceCode" = "software",
  "VideoObject" = NULL,
  "WebPage" = NULL,
  "WebSite" = "website"
)

SO_TO_CP_TRANSLATIONS <- list(
  "Article" = "",
  "AudioObject" = "song",
  "Blog" = "report",
  "BlogPosting" = "post-weblog",
  "Collection" = NULL,
  "CreativeWork" = NULL,
  "DataCatalog" = "dataset",
  "Dataset" = "dataset",
  "Event" = NULL,
  "ImageObject" = "graphic",
  "Movie" = "motion_picture",
  "PublicationIssue" = NULL,
  "ScholarlyArticle" = "article-journal",
  "Service" = NULL,
  "Thesis" = "thesis",
  "VideoObject" = "broadcast",
  "WebPage" = "webpage",
  "WebSite" = "webpage"
)

SO_TO_RIS_TRANSLATIONS <- list(
  "Article" = NULL,
  "AudioObject" = NULL,
  "Blog" = NULL,
  "BlogPosting" = "BLOG",
  "Collection" = NULL,
  "CreativeWork" = "GEN",
  "DataCatalog" = "CTLG",
  "Dataset" = "DATA",
  "Event" = NULL,
  "ImageObject" = "FIGURE",
  "Movie" = "MPCT",
  "PublicationIssue" = NULL,
  "ScholarlyArticle" = "JOUR",
  "Service" = NULL,
  "SoftwareSourceCode" = "COMP",
  "VideoObject" = "VIDEO",
  "WebPage" = "ELEC",
  "WebSite" = NULL
)

CR_TO_RIS_TRANSLATIONS <- list(
  "Proceedings" = "CONF",
  "ReferenceBook" = "BOOK",
  "JournalIssue" = NULL,
  "ProceedingsArticle" = "CPAPER",
  "Other" = "GEN",
  "Dissertation" = "THES",
  "Dataset" = "DATA",
  "EditedBook" = "BOOK",
  "JournalArticle" = "JOUR",
  "Journal" = NULL,
  "Report" = NULL,
  "BookSeries" = NULL,
  "ReportSeries" = NULL,
  "BookTrack" = NULL,
  "Standard" = NULL,
  "BookSection" = "CHAP",
  "BookPart" = "CHAP",
  "Book" = "BOOK",
  "BookChapter" = "CHAP",
  "StandardSeries" = NULL,
  "Monograph" = "BOOK",
  "Component" = NULL,
  "ReferenceEntry" = "DICT",
  "JournalVolume" = NULL,
  "BookSet" = NULL
)

DC_TO_RIS_TRANSLATIONS <- list(
  "Audiovisual" = "MPCT",
  "Collection" = NULL,
  "Dataset" = "DATA",
  "Event" = NULL,
  "Image" = "FIGURE",
  "InteractiveResource" = NULL,
  "Model" = NULL,
  "PhysicalObject" = NULL,
  "Service" = NULL,
  "Software" = "COMP",
  "Sound" = "SOUND",
  "Text" = "RPRT",
  "Workflow" = NULL,
  "Other" = NULL
)

SO_TO_BIB_TRANSLATIONS <- list(
  "Article" = "article",
  "AudioObject" = "misc",
  "Thesis" = "phdthesis",
  "Blog" = "misc",
  "BlogPosting" = "article",
  "Collection" = "misc",
  "CreativeWork" = "misc",
  "DataCatalog" = "misc",
  "Dataset" = "misc",
  "Event" = "misc",
  "ImageObject" = "misc",
  "Movie" = "misc",
  "PublicationIssue" = "misc",
  "ScholarlyArticle" = "article",
  "Service" = "misc",
  "SoftwareSourceCode" = "misc",
  "VideoObject" = "misc",
  "WebPage" = "misc",
  "WebSite" = "misc"
)
