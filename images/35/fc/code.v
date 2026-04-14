module divider_4bit (
    input [3:0] dividend,
    input [3:0] divisor,
    input clk,
    input reset,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg div_by_zero
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            quotient <= 4'b0000;
            remainder <= 4'b0000;
            div_by_zero <= 1'b0;
        end else begin
            if (divisor == 4'b0000) begin
                div_by_zero <= 1'b1;
                quotient <= 4'b0000;
                remainder <= dividend; // Default case to return dividend as remainder
            end else begin
                div_by_zero <= 1'b0;
                quotient <= dividend / divisor;
                remainder <= dividend % divisor;
            end
        end
    end
endmodule