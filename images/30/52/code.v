module fir_filter(
    input [4:0] x,      // 5-bit input
    output [4:0] y      // 5-bit output
);
    reg [4:0] y_reg;

    always @* begin
        y_reg = (x[0] + x[1] + x[2] + x[3] + x[4]); // sum of inputs
    end

    assign y = y_reg;
endmodule