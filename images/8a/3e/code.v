module top_module(
    input clk,
    input rst,
    input wescr,
    input [15:0] aluout,
    output reg [15:0] out
  );reg [15:0] M_score_d, M_score_q = 1'h0;
  
  always @* begin
    M_score_d = M_score_q;
    
    out = M_score_q;
    if (wescr) begin
      M_score_d = aluout;
    end
  end
  
  always @(posedge clk) begin
    if (rst == 1'b1) begin
      M_score_q <= 1'h0;
    end else begin
      M_score_q <= M_score_d;
    end
  end
  
endmodule