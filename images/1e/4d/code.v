module fir_filter (
    input [4:0] x,          // current input sample
    input [4:0] x1,         // previous input sample
    input [4:0] x2,         // input sample before previous
    output reg [4:0] y      // output sample
);

always @(*) begin
    y = (x * 1 + x1 * 2 + x2 * 1) >> 1;
end
endmodule