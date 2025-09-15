# Ada-Programming-Language

This repository collects idioms, patterns, and clean code examples written in Ada. It now includes a small digital signal processing (DSP) toolset that can be used to experiment with real-world algorithms and compare their behaviour with implementations in other languages.

## DSP building blocks

The Ada packages under `src/` implement reusable DSP components:

* `DSP.Types` defines common numeric and complex sample types that are reused across the library.
* `DSP.Windows` provides Hamming, Hann, and Blackman window coefficient generators that are useful for spectral analysis and FIR filter design.
* `DSP.Filters.FIR` implements a direct-form finite impulse response filter with streaming sample and block based processing helpers.
* `DSP.Filters.IIR.Biquad` implements a transposed direct-form II biquad with helpers for low-pass, high-pass, and band-pass design using the RBJ cookbook formulae.
* `DSP.Transforms.DFT` provides straightforward forward and inverse discrete Fourier transforms that operate on the `Sample_Array` and `Complex_Array` types.

### Example usage

```ada
with DSP.Filters.FIR;
with DSP.Filters.IIR.Biquad;
with DSP.Types;

procedure Demo is
   use DSP.Types;

   Samples : constant Sample_Array := (1 => 1.0, 2 => 0.0, 3 => 0.0, 4 => -1.0);
   Filter  : DSP.Filters.FIR.FIR_Filter (Order => 3);
   Output  : Sample_Array (Samples'Range);
begin
   DSP.Filters.FIR.Set_Coefficients
     (Filter,
      Coefs => (1 => 0.25, 2 => 0.5, 3 => 0.25));

   DSP.Filters.FIR.Process (Filter, Samples, Output);
end Demo;
```

The packages are designed to be composable: feed a window into a filter design routine, cascade multiple biquads, or analyse a signal with the DFT.

## Building

The repository does not prescribe a specific project file. Add the `src/` directory to your GNAT project and compile the required units. For quick experiments you can create a simple project file such as:

```gpr
project DSP is
   for Source_Dirs use ("src");
end DSP;
```

Compile your test program against this project to exercise the algorithms.
