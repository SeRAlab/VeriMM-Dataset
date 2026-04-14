module top_module(CLK, EN, TE, RESET, ENCLK, Q);input CLK, EN, TE, RESET;
  output ENCLK, Q;
  
  reg Q_reg;
  wire CLK_gated;
  
  assign CLK_gated = (EN == 1'b1) ? CLK : 1'b0;
  
  always @(posedge CLK_gated or posedge RESET) begin
    if (RESET == 1'b1) begin
      Q_reg <= 1'b0;
    end else if (EN == 1'b0) begin
      Q_reg <= Q_reg;
    end else begin
      Q_reg <= TE;
    end
  end
  
  assign Q = Q_reg;
  assign ENCLK = CLK_gated;
endmodule