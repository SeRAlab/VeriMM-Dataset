module top_module(
  input [63:0] in,
  output [63:0] out_both,
  output [63:0] out_any,
  output [63:0] out_different
);// Define temporary signals
  reg [63:0] shifted_in;
  reg [63:0] shifted_out_both;
  reg [63:0] shifted_out_any;
  reg [63:0] shifted_out_different;

  // Shift input to the right by 1 bit
  assign shifted_in = {in[0], in[63:1]};

  // Compare input with its neighbor to the right for out_both
  assign shifted_out_both = in & shifted_in;

  // Compare input with its neighbor to the left for out_any
  assign shifted_out_any = in | shifted_in;

  // Compare input with its neighbor to the right for out_different
  assign shifted_out_different = in ^ shifted_in;

  // Shift output back to the left by 1 bit
  assign out_both = {shifted_out_both[62:0], shifted_out_both[63]};
  assign out_any = {shifted_out_any[62:0], shifted_out_any[63]};
  assign out_different = {shifted_out_different[62:0], shifted_out_different[63]};

endmodule