with Ada.Numerics.Generic_Complex_Types;

package DSP.Types is
   type Sample is digits 15;
   type Sample_Array is array (Positive range <>) of Sample;

   package Sample_Complex_Types is new Ada.Numerics.Generic_Complex_Types (Sample);
   subtype Complex_Sample is Sample_Complex_Types.Complex;
   type Complex_Array is array (Positive range <>) of Complex_Sample;

   function To_Complex (Re : Sample; Im : Sample := 0.0) return Complex_Sample;

   function Magnitude (Value : Complex_Sample) return Sample;
end DSP.Types;
