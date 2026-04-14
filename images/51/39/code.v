module top_module(D, clk, rst, Q);input [4:0] D;
  output [4:0] Q;
  input clk, rst;
  wire n1, n2, n3, n4;

  // Simple D Flip-Flop with active-low reset
  reg [4:0] Q_reg;
  
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      Q_reg <= 5'b0; // Active low reset
    end else begin
      Q_reg <= D; // On clock edge, store input D
    end
  end

  // Assign the output
  assign Q = Q_reg;

  // Inverters
  assign Q[3] = ~Q_reg[0];
  assign Q[2] = ~Q_reg[1];
  assign Q[1] = ~Q_reg[2];
  assign Q[0] = ~Q_reg[3];
  
endmodule