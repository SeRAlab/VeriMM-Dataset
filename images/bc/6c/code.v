module top_module(CLK, EN, TE, ENCLK);input CLK, EN, TE;
  output ENCLK;

  reg [1:0] stage1, stage2;

  always @(posedge CLK) begin
    if (EN) begin
      stage1 <= TE ? 1'b1 : 1'b0;
      stage2 <= stage1;
    end
  end

  assign ENCLK = stage2 & CLK;

endmodule