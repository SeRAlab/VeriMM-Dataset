module top_module(
    input clk,
    input [3:0] in,
    output reg [3:0] out
);reg [3:0] buffer [0:3];
reg [1:0] ptr = 0;

always @(posedge clk) begin
    buffer[ptr] <= in;
    ptr <= (ptr == 3) ? 0 : ptr + 1;
end

always @(posedge clk) begin
    out <= buffer[ptr];
end

endmodule