module top_module( 
  CLK,
  RST,
  D,
  I, 
  Q
);input CLK, RST, D, I;
  output Q;

  reg Q;

  always @(posedge CLK or posedge RST) begin
    if (RST) begin
      Q <= I;
    end else begin
      Q <= D;
    end
  end

endmodule