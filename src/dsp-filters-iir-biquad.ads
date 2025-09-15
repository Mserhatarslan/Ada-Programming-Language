with DSP.Types;

package DSP.Filters.IIR.Biquad is
   type Coefficients is record
      B0 : DSP.Types.Sample := 1.0;
      B1 : DSP.Types.Sample := 0.0;
      B2 : DSP.Types.Sample := 0.0;
      A1 : DSP.Types.Sample := 0.0;
      A2 : DSP.Types.Sample := 0.0;
   end record;

   type State is record
      Z1 : DSP.Types.Sample := 0.0;
      Z2 : DSP.Types.Sample := 0.0;
   end record;

   type Biquad_Filter is tagged record
      Coefs : Coefficients := (B0 => 1.0, others => 0.0);
      State : State;
   end record;

   procedure Set_Coefficients
     (Filter : in out Biquad_Filter;
      Value  : Coefficients);

   procedure Reset (Filter : in out Biquad_Filter);

   function Process_Sample
     (Filter : in out Biquad_Filter;
      Input  : DSP.Types.Sample) return DSP.Types.Sample;

   procedure Process
     (Filter : in out Biquad_Filter;
      Input  : DSP.Types.Sample_Array;
      Output : out DSP.Types.Sample_Array);

   function Low_Pass
     (Frequency    : DSP.Types.Sample;
      Q            : DSP.Types.Sample;
      Sample_Rate  : DSP.Types.Sample) return Coefficients;

   function High_Pass
     (Frequency    : DSP.Types.Sample;
      Q            : DSP.Types.Sample;
      Sample_Rate  : DSP.Types.Sample) return Coefficients;

   function Band_Pass
     (Frequency    : DSP.Types.Sample;
      Q            : DSP.Types.Sample;
      Sample_Rate  : DSP.Types.Sample) return Coefficients;
end DSP.Filters.IIR.Biquad;
