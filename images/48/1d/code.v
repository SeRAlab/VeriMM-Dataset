module top_module(aclk,
    input_signals,
    lut_output,
    ff_output);input aclk;
  input [1:0] input_signals;
  output lut_output;
  output ff_output;
  
  wire const0;
  wire const1;
  wire pre_rdy;
  wire lut_output;
  wire ff_output;
  
  // Define constants explicitly
  assign const0 = 1'b0; // Ground
  assign const1 = 1'b1; // VCC
  
  // Implement a 2-input LUT using a simple combinational logic
  assign pre_rdy = (input_signals[0] & input_signals[1]) | (input_signals[0] & const1) | (input_signals[1] & const1);
  
  // Flip-flop with asynchronous reset
  reg ff_reg;
  always @(posedge aclk or posedge const0) begin
    if (const0) 
      ff_reg <= 1'b0;
    else 
      ff_reg <= pre_rdy;
  end
  
  assign ff_output = ff_reg;
  
  assign lut_output = pre_rdy;
  
endmodule