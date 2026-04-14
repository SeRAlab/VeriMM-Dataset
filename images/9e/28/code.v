module top_module(
  input CLK,
  input EN,
  input TE,
  output reg ENCLK
);always @(posedge CLK or posedge TE) begin
    if (TE) 
      ENCLK <= EN; 
  end

endmodule