package body DSP.Filters.FIR is
   use DSP.Types;

   procedure Set_Coefficients
     (Filter : in out FIR_Filter;
      Coefs  : DSP.Types.Sample_Array)
   is
   begin
      if Coefs'Length /= Filter.Order then
         raise Constraint_Error with "Coefficient length does not match filter order";
      end if;

      Filter.Coefficients := Coefs;
   end Set_Coefficients;

   procedure Reset (Filter : in out FIR_Filter) is
   begin
      Filter.Buffer   := (others => 0.0);
      Filter.Position := 1;
   end Reset;

   function Process_Sample
     (Filter : in out FIR_Filter;
      Input  : DSP.Types.Sample) return DSP.Types.Sample
   is
      Accumulator : Sample := 0.0;
      Index       : Positive := Filter.Position;
   begin
      Filter.Buffer (Filter.Position) := Input;

      for Coef_Index in Filter.Coefficients'Range loop
         Accumulator := Accumulator + Filter.Coefficients (Coef_Index) * Filter.Buffer (Index);

         if Index = 1 then
            Index := Filter.Order;
         else
            Index := Index - 1;
         end if;
      end loop;

      if Filter.Position = Filter.Order then
         Filter.Position := 1;
      else
         Filter.Position := Filter.Position + 1;
      end if;

      return Accumulator;
   end Process_Sample;

   procedure Process
     (Filter : in out FIR_Filter;
      Input  : DSP.Types.Sample_Array;
      Output : out DSP.Types.Sample_Array)
   is
   begin
      if Input'Length /= Output'Length then
         raise Constraint_Error with "Input and output buffers must have identical lengths";
      end if;

      for Index in Input'Range loop
         Output (Index) := Process_Sample (Filter => Filter, Input => Input (Index));
      end loop;
   end Process;
end DSP.Filters.FIR;
