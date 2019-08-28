#write GIN-like yml

cat (paste0("# data uplaoded by ",updated_by, " inside the project ", thisproject))

cat ("

authors:
")

for (j in c(1:nrow(projects_authors))) {
  #print (j)
  cat(
    '  -
    firstname: "', projects_authors$contributor_firstname[j], '"
    lastname: "', projects_authors$contributor_lastname[j],'"
    affiliation: "',projects_authors$contributor_affiliation[j], '"'
    , sep = "")
  
  if (!is.na(projects_authors$contributor_orcid[j])) {
    cat('
    id: "http://orcid.org/', projects_authors$contributor_orcid[j], '"'
        , sep = "")    
  }
}

cat ('
title: "',title1,'"' , sep = "")

cat ('
description: |
  ',caption, sep = "")

cat ('
license:
  name: "CC-BY"
  url: "https://creativecommons.org/licenses/by/4.0/"

## Optional Fields

# Any funding reference for this resource. Separate funder name and grant number by comma
funding:
  - "DFG, Project number 327654276 – SFB 1315"', sep ="")
if (url != "none"){
  cat('
# Related publications. reftype might be: IsCitedBy, IsSupplementTo, IsReferencedBy, IsPartOf
# for further valid types see https://schema.datacite.org/meta/kernel-4
# Please provide digital identifier (e.g., DOI) if possible.
references:
  -
    doi: "', url,'"
    reftype: "IsPartOf"
    name: "noName"    
    
    ')}




#cat ("
#     ")
#kable (projects_authors %>% filter (project == thisproject) %>% select(- Project_title))
