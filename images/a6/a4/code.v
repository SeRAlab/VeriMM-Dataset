module top_module(
  input [7:0] A,
  input [7:0] B,
  input C,
  output reg [7:0] sum
);always @(*)
  begin
    // add the inputs
    sum = A + B;

    // truncate if necessary
    if(sum > 8'b11111111)
      sum = sum[7:0];

    // convert to two's complement if required
    if(C)
      sum = ~sum + 1;
  end

endmodule