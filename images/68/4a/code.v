module top_module(
  input [3:0] in,
  output reg out
);integer i;
  reg [1:0] count;

  always @(*) begin
    count = 0;
    for (i = 0; i < 4; i = i + 1) begin
      count = count + in[i];
    end
    out = (count % 2 == 0) ? 1'b0 : 1'b1;
  end

endmodule