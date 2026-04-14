module top_module(clock, a_in, b_in, out);input clock;
input [7:0] a_in;
input [7:0] b_in;
output reg [7:0] out;

reg [7:0] temp;

always @(posedge clock) begin
    temp <= a_in | b_in;
    out <= a_in ^ temp;
end

endmodule