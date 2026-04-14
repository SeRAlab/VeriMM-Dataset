module top_module(D, en, clk, rst, Q);input [4:0] D;
  output [4:0] Q;
  input en, clk, rst;

  wire [4:0] shifted_D;
  reg [4:0] Q_reg; // Changed from wire to reg

  assign shifted_D = {D[3:0], 1'b0};
  
  always @(posedge clk or posedge rst) begin
    if(rst) begin
      Q_reg <= 5'b0;
    end else if(en) begin
      Q_reg <= shifted_D;
    end
  end

  assign Q = Q_reg;

endmodule