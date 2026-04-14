module top_module(
  output reg Q,
  input D,
  input CLK,
  input EN,
  input CLR
);always @(posedge CLK or posedge CLR) begin
    if (CLR)
      Q <= 1'b0;
    else if (EN)
      Q <= D;
  end
endmodule