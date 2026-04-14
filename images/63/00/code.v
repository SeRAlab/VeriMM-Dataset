module top_module(
  input [31:0] in,
  output reg [15:0] out
);reg [31:0] x_n;
  reg [31:0] x_next;
  integer i;

  always @(*) begin
    x_n = in/2;
    for (i = 0; i < 10; i = i + 1) begin
      x_next = (x_n + in/x_n)/2;
      x_n = x_next;
    end
    out = x_n[15:0];
  end

endmodule