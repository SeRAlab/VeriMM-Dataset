module divider_4bit(
    input clk,
    input [3:0] numerator,
    input [3:0] denominator,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg valid
);

    always @(posedge clk) begin
        if (denominator != 0) begin
            quotient <= numerator / denominator;
            remainder <= numerator % denominator;
            valid <= 1'b1;
        end else begin
            quotient <= 4'b0000; // Undefined behavior for division by zero
            remainder <= 4'b0000;
            valid <= 1'b0;
        end
    end
endmodule