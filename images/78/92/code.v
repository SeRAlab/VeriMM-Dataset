module top_module(clk, rst, load, D, Q);input clk, rst, load, D;
  output reg [0:0] Q;  // Declare Q as a register

  wire n1, n2, n4;

  // Using a standard D flip-flop
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      Q <= 1'b0; // Reset Q to 0
    end else if (load) begin
      Q <= D; // Load D into Q if load is high
    end
  end

  // Inversions and logic gates
  assign n1 = ~load;  // Invert load
  assign n2 = ~rst;   // Invert rst
  assign n4 = (n1 & Q) | (load & D); // Implementing AO22 functionality

endmodule