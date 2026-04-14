module top_module(Q,
    E,
    R,
    D,
    CLK);output reg [31:0]Q;
  input E;
  input R;
  input [31:0]D;
  input CLK;

  always @(posedge CLK) begin
    if (R) begin
      Q <= 0;
    end else if (E) begin
      Q <= D;
    end
  end
endmodule