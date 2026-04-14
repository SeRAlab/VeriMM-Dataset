module top_module(
  input clk,
  input din,
  input load,
  input ctrl,
  output reg dout
);parameter WIDTH = 8; // configurable length of shift register
  
  reg [WIDTH-1:0] shift_reg; // shift register
  
  always @(posedge clk) begin
    if (load) // parallel load
      shift_reg <= {din, shift_reg[WIDTH-1:1]}; // corrected parallel load
    else if (ctrl) // shift in one direction
      shift_reg <= {shift_reg[WIDTH-2:0], shift_reg[WIDTH-1]};
    else // shift in opposite direction
      shift_reg <= {shift_reg[0], shift_reg[WIDTH-1:1]}; // corrected shifting in opposite direction
  end
  
  assign dout = shift_reg[WIDTH-1]; // output of shift register
  
endmodule