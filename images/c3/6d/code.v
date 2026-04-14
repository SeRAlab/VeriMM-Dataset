module bin2gray (
    input [3:0] in,
    input clk,
    output reg [3:0] out
);

always @(posedge clk) begin
    out[0] <= in[0];
    out[1] <= in[0] ^ in[1];
    out[2] <= in[1] ^ in[2];
    out[3] <= in[2] ^ in[3];
end

endmodule