with Ada.Numerics.Generic_Elementary_Functions;

package body DSP.Transforms.DFT is
   use DSP.Types;

   package Math is new Ada.Numerics.Generic_Elementary_Functions (Sample);

   function Forward (Input : Sample_Array) return Complex_Array is
      Result      : Complex_Array (Input'Range);
      Samples     : constant Sample := Sample (Input'Length);
      First_Index : constant Positive := Input'First;
   begin
      for K in Input'Range loop
         declare
            Sum_Re : Sample := 0.0;
            Sum_Im : Sample := 0.0;
            K_Pos  : constant Sample := Sample (Integer (K - First_Index));
         begin
            for N in Input'Range loop
               declare
                  N_Pos   : constant Sample := Sample (Integer (N - First_Index));
                  Angle   : constant Sample := -2.0 * Math.Pi * K_Pos * N_Pos / Samples;
                  Cos_A   : constant Sample := Math.Cos (Angle);
                  Sin_A   : constant Sample := Math.Sin (Angle);
                  Sample_ : constant Sample := Input (N);
               begin
                  Sum_Re := Sum_Re + Sample_ * Cos_A;
                  Sum_Im := Sum_Im - Sample_ * Sin_A;
               end;
            end loop;

            Result (K) := To_Complex (Sum_Re, Sum_Im);
         end;
      end loop;

      return Result;
   end Forward;

   function Inverse (Input : Complex_Array) return Sample_Array is
      Result      : Sample_Array (Input'Range);
      Samples     : constant Sample := Sample (Input'Length);
      First_Index : constant Positive := Input'First;
   begin
      for N in Input'Range loop
         declare
            Sum : Sample := 0.0;
            N_Pos  : constant Sample := Sample (Integer (N - First_Index));
         begin
            for K in Input'Range loop
               declare
                  K_Pos   : constant Sample := Sample (Integer (K - First_Index));
                  Angle   : constant Sample := 2.0 * Math.Pi * K_Pos * N_Pos / Samples;
                  Cos_A   : constant Sample := Math.Cos (Angle);
                  Sin_A   : constant Sample := Math.Sin (Angle);
                  Value   : constant Complex_Sample := Input (K);
               begin
                  Sum := Sum + Value.Re * Cos_A - Value.Im * Sin_A;
               end;
            end loop;

            Result (N) := Sum / Samples;
         end;
      end loop;

      return Result;
   end Inverse;
end DSP.Transforms.DFT;
