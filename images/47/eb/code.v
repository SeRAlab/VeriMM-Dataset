module top_module(input clk, input a, input b, output out);// Clock input for shifting the stored inputs through the shift register
  // Two binary inputs a and b to be stored in the shift register
  // Binary output out generated from the logical AND of the stored inputs.

  // 3-bit shift register
  reg [2:0] shift_reg;
  
  always @(posedge clk) begin
    shift_reg <= {shift_reg[1:0], a};  // Shift in the new value 'a'
  end
  
  // AND operation for the inputs a and b
  wire and_out;
  assign and_out = a & b;  // Logical AND of inputs a and b
  
  // Output generated from the logical AND of the stored inputs
  assign out = and_out & shift_reg[2];  // AND with the most recent input stored in the shift register
endmodule