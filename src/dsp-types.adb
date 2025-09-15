with Ada.Numerics.Generic_Elementary_Functions;

package body DSP.Types is
   package Math is new Ada.Numerics.Generic_Elementary_Functions (Sample);
   use Sample_Complex_Types;

   function To_Complex (Re : Sample; Im : Sample := 0.0) return Complex_Sample is
   begin
      return (Re => Re, Im => Im);
   end To_Complex;

   function Magnitude (Value : Complex_Sample) return Sample is
   begin
      return Math.Sqrt (Value.Re * Value.Re + Value.Im * Value.Im);
   end Magnitude;
end DSP.Types;
