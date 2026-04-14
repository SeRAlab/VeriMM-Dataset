module top_module(
  input CLK,
  input EN,
  input TE,
  output reg ENCLK
);reg CLK_D;
  
  always @(posedge CLK) begin
    CLK_D <= CLK;
  end
  
  always @(posedge CLK) begin
    if (EN && TE) begin
      ENCLK <= CLK_D;
    end
  end

endmodule