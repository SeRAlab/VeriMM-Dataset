module top_module(
  input [7:0] a,
  input [7:0] b,
  input select,
  output reg led
);reg [7:0] result;

  always @(*) begin
    if (select == 1'b0) begin
      result = a;
    end else begin
      result = b;
    end
  end

  assign led = result[7];

endmodule