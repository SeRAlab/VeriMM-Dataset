module fir_filter (
    input [3:0] x,      // 4-bit input
    output [5:0] y      // 6-bit output
);
    reg [5:0] y_reg;    // Register to hold the output

    always @(*) begin
        y_reg = (1 * x) + (2 * x) + (3 * x) + (4 * x);
    end

    assign y = y_reg;

endmodule