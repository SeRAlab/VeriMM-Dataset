module top_module(input clk, output reg q);reg [2:0] shift_reg;
  wire d; // Define d as a wire

  always @(posedge clk)
    shift_reg <= {shift_reg[1:0], d};

  assign q = shift_reg[2];

  // Assigning a value to d for functionality 
  assign d = ~shift_reg[2]; // Example of generating a value for d

endmodule