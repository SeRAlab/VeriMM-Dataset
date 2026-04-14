module fir_filter (
    input [3:0] x, // 4-bit input signal
    output reg [7:0] y // 8-bit output signal (to accommodate sum)
);
    always @(*) begin
        y = (x * 1) + (x * 2) + (x * 3) + (x * 4);
    end
endmodule