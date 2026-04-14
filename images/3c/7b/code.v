module fir_filter (
    input [7:0] x0, // input sample 0
    input [7:0] x1, // input sample 1
    input [7:0] x2, // input sample 2
    output reg [7:0] y // output sample
);
    always @(*) begin
        y = (x0 + (x1 << 1) + x2) >> 2; // output calculation
    end
endmodule