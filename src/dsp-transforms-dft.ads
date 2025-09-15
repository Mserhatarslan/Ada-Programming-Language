with DSP.Types;

package DSP.Transforms.DFT is
   function Forward (Input : DSP.Types.Sample_Array) return DSP.Types.Complex_Array;
   function Inverse (Input : DSP.Types.Complex_Array) return DSP.Types.Sample_Array;
end DSP.Transforms.DFT;
