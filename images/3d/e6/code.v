module fir_filter (
    input [3:0] x, // 4-bit input data
    output reg [7:0] y // 8-bit output data (to accommodate the sum)
);
    always @(*) begin
        y = (x * 1) + (x * 2) + (x * 3) + (x * 4);
    end
endmodule