module divider (
    input clk,
    input reset,
    input valid,
    input [3:0] dividend,
    input [3:0] divisor,
    output reg [3:0] quotient,
    output reg [3:0] remainder
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            quotient <= 4'b0000;
            remainder <= 4'b0000;
        end else if (valid) begin
            if (divisor == 4'b0000) begin
                quotient <= 4'b0000;
                remainder <= dividend;
            end else begin
                quotient <= dividend / divisor;
                remainder <= dividend % divisor;
            end
        end
    end
endmodule