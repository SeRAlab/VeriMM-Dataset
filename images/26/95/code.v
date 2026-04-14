module divider (
    input wire clk,
    input wire reset,
    input wire [7:0] numerator,
    output reg [7:0] quotient,
    output reg [1:0] remainder
);
    parameter DIVISOR = 3; // Constant divisor

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            quotient <= 0;
            remainder <= 0;
        end else begin
            quotient <= numerator / DIVISOR;
            remainder <= numerator % DIVISOR;
        end
    end
endmodule