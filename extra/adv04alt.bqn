# Some solutions from the BQN community (to be "decoded" later):

# https://codeberg.org/Rampoina/aoc/
Count←+´⍷⟜(⌽⊸∾)
D←(+⌜´↕¨∘≢)⊸⊔
•Show+´∾"XMAS"⊸Count¨¨⟨<˘,<˘⍉,D,D⌽⟩{𝕎𝕩}¨<>data
•Show+´∧´¨"MAS"⊸Count¨¨⥊{⟨2⊸⊑D,2⊸⊑D∘⌽⟩{𝕎𝕩}¨<𝕩}¨<⎉2 3‿3↕>data

# https://github.com/dzaima/aoc/
a←⌽∘⍉⍟(↕4)data
lp←data∾˘' '¨data
b←(-↕≠data)⌽˘lp
c←(↕≠data)⌽˘lp
•Show+´{+´⥊"XMAS"⍷𝕩}¨a∾⍉¨⌽¨⊸∾b‿c
•Show+´{+´⥊∧˝∾˝["M.S",".A.","M.S"](= ∨ =⟜'.')(¯2+≢)⊸↕𝕩}¨a

# https://github.com/cooijmanstim/advent2024/
Swizzle←{↑‿(1+2×¯1⊑≢𝕩)⥊𝕩∾˘' '¨𝕩}
x←>data
haystacks←∾´⟨<˘x,<˘⍉x,<˘⍉Swizzle x,<˘⍉Swizzle⌽x⟩
needles←"XMAS"‿"SAMX"
•Show+´⥊(+´∘⥊)¨needles⍷⌜haystacks
•Show+´⥊{∧´∨´<˘"MAS"‿"SAM"≡⌜<˘(2‿4‿6≍0‿4‿8)⊏⥊𝕩}⎉2 3‿3↕x
