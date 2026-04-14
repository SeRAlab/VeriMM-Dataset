module top_module(ctrl0,
    ctrl1,
    D0,
    D1,
    D2,
    D3,
    S,
    valid);input ctrl0;
  input ctrl1;
  input D0;  // Changed from input [0:0] to input (1-bit)
  input D1;  // Changed from input [0:0] to input (1-bit)
  input D2;  // Changed from input [0:0] to input (1-bit)
  input D3;  // Changed from input [0:0] to input (1-bit)
  output S;  // Changed from output [0:0] to output (1-bit)
  output valid;

  assign valid = (ctrl0 == 0 && ctrl1 == 0) || (ctrl0 == 0 && ctrl1 == 1) || (ctrl0 == 1 && ctrl1 == 0) || (ctrl0 == 1 && ctrl1 == 1);

  // Removed LUT4 instantiation as it is not a standard Verilog feature and not recognized
  assign S = (ctrl0 == 0 && ctrl1 == 0) ? D0 : 
             (ctrl0 == 0 && ctrl1 == 1) ? D1 :
             (ctrl0 == 1 && ctrl1 == 0) ? D2 : D3;
endmodule