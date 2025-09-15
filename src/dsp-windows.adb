with Ada.Numerics.Generic_Elementary_Functions;

package body DSP.Windows is
   package Math is new Ada.Numerics.Generic_Elementary_Functions (DSP.Types.Sample);
   use DSP.Types;

   function Window_Value (Length : Positive; Index : Natural; A0, A1, A2 : Sample) return Sample;

   function Window_Value (Length : Positive; Index : Natural; A0, A1, A2 : Sample) return Sample is
      Denominator : constant Sample := (if Length = 1 then 1.0 else Sample (Length - 1));
      Argument    : constant Sample := 2.0 * Sample (Index) * Math.Pi / Denominator;
   begin
      return A0 - A1 * Math.Cos (Argument) + A2 * Math.Cos (2.0 * Argument);
   end Window_Value;

   function Hamming (Length : Positive) return Sample_Array is
      Result : Sample_Array (1 .. Length);
   begin
      for I in Result'Range loop
         Result (I) := Window_Value (Length => Length, Index => I - 1, A0 => 0.54, A1 => 0.46, A2 => 0.0);
      end loop;
      return Result;
   end Hamming;

   function Hann (Length : Positive) return Sample_Array is
      Result : Sample_Array (1 .. Length);
   begin
      for I in Result'Range loop
         Result (I) := Window_Value (Length => Length, Index => I - 1, A0 => 0.5, A1 => 0.5, A2 => 0.0);
      end loop;
      return Result;
   end Hann;

   function Blackman (Length : Positive) return Sample_Array is
      Result : Sample_Array (1 .. Length);
   begin
      for I in Result'Range loop
         Result (I) := Window_Value (Length => Length, Index => I - 1, A0 => 0.42, A1 => 0.5, A2 => 0.08);
      end loop;
      return Result;
   end Blackman;
end DSP.Windows;
