module clock_gate_flop(gated_clk, clk, en);
  input clk, en;
  output reg gated_clk;
  
  always @(posedge clk) begin
    if (en) begin
      gated_clk <= 1'b1;
    end
    else begin
      gated_clk <= 1'b0;
    end
  end
endmodule