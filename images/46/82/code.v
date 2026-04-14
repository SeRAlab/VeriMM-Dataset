module top_module(
    input [3:0] in,
    output reg [15:0] out
);always @(*) begin
    out[15:12] = in;
    out[11:8] = in << 1;
    out[7:4] = in << 2;
    out[3:0] = in << 3;
end

endmodule