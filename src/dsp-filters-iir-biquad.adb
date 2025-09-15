with Ada.Numerics.Generic_Elementary_Functions;

package body DSP.Filters.IIR.Biquad is
   use DSP.Types;

   package Math is new Ada.Numerics.Generic_Elementary_Functions (Sample);

   procedure Validate_Parameters
     (Frequency   : Sample;
      Q           : Sample;
      Sample_Rate : Sample) is
   begin
      if Sample_Rate <= 0.0 then
         raise Constraint_Error with "Sample rate must be positive";
      elsif Frequency <= 0.0 or else Frequency >= Sample_Rate / 2.0 then
         raise Constraint_Error with "Frequency must be within (0, Sample_Rate / 2)";
      elsif Q <= 0.0 then
         raise Constraint_Error with "Q must be positive";
      end if;
   end Validate_Parameters;

   procedure Set_Coefficients
     (Filter : in out Biquad_Filter;
      Value  : Coefficients) is
   begin
      Filter.Coefs := Value;
   end Set_Coefficients;

   procedure Reset (Filter : in out Biquad_Filter) is
   begin
      Filter.State := (others => 0.0);
   end Reset;

   function Process_Sample
     (Filter : in out Biquad_Filter;
      Input  : Sample) return Sample
   is
      Y : Sample := Filter.Coefs.B0 * Input + Filter.State.Z1;
   begin
      Filter.State.Z1 := Filter.Coefs.B1 * Input + Filter.State.Z2 - Filter.Coefs.A1 * Y;
      Filter.State.Z2 := Filter.Coefs.B2 * Input - Filter.Coefs.A2 * Y;
      return Y;
   end Process_Sample;

   procedure Process
     (Filter : in out Biquad_Filter;
      Input  : Sample_Array;
      Output : out Sample_Array)
   begin
      if Input'Length /= Output'Length then
         raise Constraint_Error with "Input and output buffers must have identical lengths";
      end if;

      for Index in Input'Range loop
         Output (Index) := Process_Sample (Filter => Filter, Input => Input (Index));
      end loop;
   end Process;

   function Normalize (B0, B1, B2, A0, A1, A2 : Sample) return Coefficients;

   function Normalize (B0, B1, B2, A0, A1, A2 : Sample) return Coefficients is
      Inv_A0 : constant Sample := 1.0 / A0;
   begin
      return (B0 => B0 * Inv_A0,
              B1 => B1 * Inv_A0,
              B2 => B2 * Inv_A0,
              A1 => A1 * Inv_A0,
              A2 => A2 * Inv_A0);
   end Normalize;

   function Low_Pass
     (Frequency    : Sample;
      Q            : Sample;
      Sample_Rate  : Sample) return Coefficients
   is
      W0    : constant Sample := 2.0 * Math.Pi * Frequency / Sample_Rate;
      Cos_W : constant Sample := Math.Cos (W0);
      Sin_W : constant Sample := Math.Sin (W0);
      Alpha : constant Sample := Sin_W / (2.0 * Q);
   begin
      Validate_Parameters (Frequency, Q, Sample_Rate);

      return Normalize
        (B0 => (1.0 - Cos_W) / 2.0,
         B1 => 1.0 - Cos_W,
         B2 => (1.0 - Cos_W) / 2.0,
         A0 => 1.0 + Alpha,
         A1 => -2.0 * Cos_W,
         A2 => 1.0 - Alpha);
   end Low_Pass;

   function High_Pass
     (Frequency    : Sample;
      Q            : Sample;
      Sample_Rate  : Sample) return Coefficients
   is
      W0    : constant Sample := 2.0 * Math.Pi * Frequency / Sample_Rate;
      Cos_W : constant Sample := Math.Cos (W0);
      Sin_W : constant Sample := Math.Sin (W0);
      Alpha : constant Sample := Sin_W / (2.0 * Q);
   begin
      Validate_Parameters (Frequency, Q, Sample_Rate);

      return Normalize
        (B0 => (1.0 + Cos_W) / 2.0,
         B1 => -(1.0 + Cos_W),
         B2 => (1.0 + Cos_W) / 2.0,
         A0 => 1.0 + Alpha,
         A1 => -2.0 * Cos_W,
         A2 => 1.0 - Alpha);
   end High_Pass;

   function Band_Pass
     (Frequency    : Sample;
      Q            : Sample;
      Sample_Rate  : Sample) return Coefficients
   is
      W0    : constant Sample := 2.0 * Math.Pi * Frequency / Sample_Rate;
      Cos_W : constant Sample := Math.Cos (W0);
      Sin_W : constant Sample := Math.Sin (W0);
      Alpha : constant Sample := Sin_W / (2.0 * Q);
   begin
      Validate_Parameters (Frequency, Q, Sample_Rate);

      return Normalize
        (B0 => Sin_W / 2.0,
         B1 => 0.0,
         B2 => -Sin_W / 2.0,
         A0 => 1.0 + Alpha,
         A1 => -2.0 * Cos_W,
         A2 => 1.0 - Alpha);
   end Band_Pass;
end DSP.Filters.IIR.Biquad;
