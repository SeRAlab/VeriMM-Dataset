module top_module(
  input [3:0] in,
  output [1:0] out
);reg [1:0] count;

always @(*) begin
  count = {in[0] + in[1], in[2] + in[3]};
end

assign out = count;

endmodule