Object subclass: #Adv03.
Adv03 class extend [
    file: name part: p [
        | data sum enable |
        sum := 0.
        enable := true.
        data := (File name: name) readStream contents.
        data allOccurrencesOfRegex: 'mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don''t\(\)'
             do: [:m |
                  m match = 'do()' ifTrue: [ enable := true ].
                  m match = 'don''t()' & p = 2 ifTrue: [ enable := false ].
                  m match ~= 'mul.*' & enable ifTrue: [
                      | a b |
                      a := Number readFrom: (ReadStream on: (m at: 1)).
                      b := Number readFrom: (ReadStream on: (m at: 2)).
                      sum := sum + (a * b)
                  ]
                 ].
        ^ sum
    ]
]
Transcript show: (Adv03 file: 'adv03.txt' part: 1) printString; cr.
Transcript show: (Adv03 file: 'adv03.txt' part: 2) printString; cr.
