module top_module(clk, in, out);input wire [31:0] in;
input wire clk;


output reg [31:0] out;

always@(*) begin
  out <= in<<2;
end

endmodule