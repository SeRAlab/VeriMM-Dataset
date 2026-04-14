module top_module(CLK, EN, TE, D, ENCLK);input CLK, EN, TE, D;
  output ENCLK;
  
  reg q;
  
  always @(posedge CLK) begin
    if (EN) begin
      q <= D;  // Use D to update the register only if EN is high
    end
  end
  
  assign ENCLK = (EN & TE) ? CLK : 1'b0;
  
endmodule