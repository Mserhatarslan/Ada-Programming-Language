with DSP.Types;

package DSP.Filters.FIR is
   type FIR_Filter (Order : Positive) is tagged record
      Coefficients : DSP.Types.Sample_Array (1 .. Order) := (others => 0.0);
      Buffer       : DSP.Types.Sample_Array (1 .. Order) := (others => 0.0);
      Position     : Positive := 1;
   end record;

   procedure Set_Coefficients
     (Filter : in out FIR_Filter;
      Coefs  : DSP.Types.Sample_Array);

   procedure Reset (Filter : in out FIR_Filter);

   function Process_Sample
     (Filter : in out FIR_Filter;
      Input  : DSP.Types.Sample) return DSP.Types.Sample;

   procedure Process
     (Filter : in out FIR_Filter;
      Input  : DSP.Types.Sample_Array;
      Output : out DSP.Types.Sample_Array);
end DSP.Filters.FIR;
