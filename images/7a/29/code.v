module top_module( CLK, EN, ENCLK, TE );input CLK, EN, TE;
  output ENCLK;

  reg Q, D;

  always @(posedge CLK) begin
    if (EN & TE) begin
      Q <= D;
    end
  end

  assign ENCLK = Q;

endmodule