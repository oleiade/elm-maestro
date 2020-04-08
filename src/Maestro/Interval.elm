module Maestro.Interval exposing
    ( Degree(..), Interval(..)
    , addInterval
    , distance
    , diatonicDegreeOf
    )

{-| This module provides types and functions to compute, represent and
manipulate intervals.


# Types

@docs Degree, Interval


# Interval calculation

@docs addInterval, distance, diatonicDegreeOf


# Scales intervals

@docs ionianIntervals, dorianIntervals, phrygianIntervals, lydianIntervals
@docs mixolydianIntervals, aeolianIntervals, locrianIntervals

-}

import Maestro.Accidental exposing (Accidental(..), accidentalFromValue, accidentalToValue)
import Maestro.Note exposing (Note, noteToIndex)
import Maestro.Pitch exposing (newPitch)
import Maestro.PitchClass
    exposing
        ( diatonicPitchClassFromValue
        , diatonicPitchClassValue
        )


{-| -}
type Degree
    = Root
    | Second
    | Third
    | Fourth
    | Fifth
    | Sixth
    | Seventh
    | Octave
    | Ninth
    | Tenth
    | Eleventh
    | Twelfth
    | Thirteenth
    | Fourteenth


{-| Interval represents the difference between two pitches
-}
type Interval
    = PerfectUnison
    | DiminishedSecond
    | MinorSecond
    | AugmentedUnison
    | MajorSecond
    | DiminishedThird
    | MinorThird
    | AugmentedSecond
    | MajorThird
    | DiminishedFourth
    | PerfectFourth
    | AugmentedThird
    | DiminishedFifth
    | AugmentedFourth
    | PerfectFifth
    | DiminishedSixth
    | MinorSixth
    | AugmentedFifth
    | MajorSixth
    | DiminishedSeventh
    | MinorSeventh
    | AugmentedSixth
    | MajorSeventh
    | DiminishedOctave
    | PerfectOctave
    | AugmentedSeventh
    | MinorNinth
    | MajorNinth
    | MinorTenth
    | MajorTenth
    | PerfectEleventh
    | AugmentedEleventh
    | PerfectTwelfth
    | MinorThirteen
    | MajorThirteen
    | MinorFourteenth
    | MajorFourteenth


{-| addInterval applies an interval to a given note, and returns
the resulting note
-}
addInterval : Note -> Interval -> Note
addInterval note interval =
    let
        newNaturalNote =
            diatonicDegreeOf (intervalDegree interval) note

        intervalSemipitches =
            intervalToValue interval

        startToNewNaturalSemipitches =
            distance note newNaturalNote

        accidental =
            accidentalFromValue (intervalSemipitches - startToNewNaturalSemipitches)

        newOctave =
            (noteToIndex newNaturalNote + accidentalToValue accidental) // 12
    in
    { pitch = newPitch newNaturalNote.pitch.class accidental, octave = newOctave }


{-| diatonicDegreeOf will compute the note being the given
degree of a starting note on the diatonic scale
-}
diatonicDegreeOf : Degree -> Note -> Note
diatonicDegreeOf degree note =
    let
        diatonicPitchClass =
            diatonicPitchClassFromValue <| remainderBy 7 (diatonicPitchClassValue note.pitch.class + degreeToValue degree)

        octaveShift =
            (diatonicPitchClassValue note.pitch.class + degreeToValue degree) // 7
    in
    case diatonicPitchClass of
        Just dk ->
            { pitch = newPitch dk Natural, octave = note.octave + octaveShift }

        Nothing ->
            note


{-| distance computes the distance in semipitches between two notes
-}
distance : Note -> Note -> Int
distance from to =
    noteToIndex to - noteToIndex from


{-| intervalToValue returns the number of semipitches corresponding
to the provided interval
-}
intervalToValue : Interval -> Int
intervalToValue interval =
    case interval of
        PerfectUnison ->
            0

        DiminishedSecond ->
            0

        MinorSecond ->
            1

        AugmentedUnison ->
            1

        MajorSecond ->
            2

        DiminishedThird ->
            2

        MinorThird ->
            3

        AugmentedSecond ->
            3

        MajorThird ->
            4

        DiminishedFourth ->
            4

        PerfectFourth ->
            5

        AugmentedThird ->
            5

        DiminishedFifth ->
            6

        AugmentedFourth ->
            6

        PerfectFifth ->
            7

        DiminishedSixth ->
            7

        MinorSixth ->
            8

        AugmentedFifth ->
            8

        MajorSixth ->
            9

        DiminishedSeventh ->
            9

        MinorSeventh ->
            10

        AugmentedSixth ->
            10

        MajorSeventh ->
            11

        DiminishedOctave ->
            11

        PerfectOctave ->
            12

        AugmentedSeventh ->
            12

        MinorNinth ->
            13

        MajorNinth ->
            14

        MinorTenth ->
            15

        MajorTenth ->
            16

        PerfectEleventh ->
            17

        AugmentedEleventh ->
            18

        PerfectTwelfth ->
            19

        MinorThirteen ->
            20

        MajorThirteen ->
            21

        MinorFourteenth ->
            22

        MajorFourteenth ->
            23


{-| intervalDegree returns the degree of an interval. You could consider the
degree as the absolute value of an interval; an interval stripped of its modal
quality (Perfect, Major, minor, augmented, diminished).
-}
intervalDegree : Interval -> Degree
intervalDegree interval =
    case interval of
        PerfectUnison ->
            Root

        DiminishedSecond ->
            Second

        MinorSecond ->
            Second

        AugmentedUnison ->
            Root

        MajorSecond ->
            Second

        DiminishedThird ->
            Third

        MinorThird ->
            Third

        AugmentedSecond ->
            Second

        MajorThird ->
            Third

        DiminishedFourth ->
            Fourth

        PerfectFourth ->
            Fourth

        AugmentedThird ->
            Third

        DiminishedFifth ->
            Fifth

        AugmentedFourth ->
            Fourth

        PerfectFifth ->
            Fifth

        DiminishedSixth ->
            Sixth

        MinorSixth ->
            Sixth

        AugmentedFifth ->
            Fifth

        MajorSixth ->
            Sixth

        DiminishedSeventh ->
            Seventh

        MinorSeventh ->
            Seventh

        AugmentedSixth ->
            Sixth

        MajorSeventh ->
            Seventh

        DiminishedOctave ->
            Octave

        PerfectOctave ->
            Octave

        AugmentedSeventh ->
            Seventh

        MinorNinth ->
            Ninth

        MajorNinth ->
            Ninth

        MinorTenth ->
            Tenth

        MajorTenth ->
            Tenth

        PerfectEleventh ->
            Eleventh

        AugmentedEleventh ->
            Eleventh

        PerfectTwelfth ->
            Twelfth

        MinorThirteen ->
            Thirteenth

        MajorThirteen ->
            Thirteenth

        MinorFourteenth ->
            Fourteenth

        MajorFourteenth ->
            Fourteenth


{-| degreeToValue returns the numeric value of a degree
-}
degreeToValue : Degree -> Int
degreeToValue d =
    case d of
        Root ->
            0

        Second ->
            1

        Third ->
            2

        Fourth ->
            3

        Fifth ->
            4

        Sixth ->
            5

        Seventh ->
            6

        Octave ->
            7

        Ninth ->
            8

        Tenth ->
            9

        Eleventh ->
            10

        Twelfth ->
            11

        Thirteenth ->
            12

        Fourteenth ->
            13
