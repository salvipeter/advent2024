# Part 1
Count←+´·⥊"XMAS"⊸⍷
dummy←@⥊˜¨↕≠data
Shift←⍉dummy⊑⊸»˘∾˘⟜(≢⊸⥊⟜@)
symms←⟨⊢,⍉,⌽˘,⌽˘⍉,Shift,Shift⍉,Shift⌽˘,Shift⍉∘(⌽˘)⟩
•Show+´(<data){Count𝕏𝕨}¨symms
# Part 2
xs←⥊⋈∘/˘'A'≡¨data
centers←⍉⌽(∾xs)∾≍(≠¨xs)/↕≠data
Corners←2‿2⥊⋈∘-⟜1∾⋈∘+⟜1∾(⊏⊸+⟜1∾⊏∘⌽⊸-⟜1)⋈⊏⊸-⟜1∾⊏∘⌽⊸+⟜1
Check←⊑∧´∘("MS"⊸≡∘∧˘⊑⟜data∘Corners)⋈(!∘∧´0⊸<)
•Show+´Check⎊0˘centers
