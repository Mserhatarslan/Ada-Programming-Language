with DSP.Types;

package DSP.Windows is
   function Hamming (Length : Positive) return DSP.Types.Sample_Array;
   function Hann (Length : Positive) return DSP.Types.Sample_Array;
   function Blackman (Length : Positive) return DSP.Types.Sample_Array;
end DSP.Windows;
