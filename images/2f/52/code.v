module divider (
    input [7:0] dividend,
    input [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    input clk,
    input reset
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            quotient <= 8'b0;
            remainder <= 8'b0;
        end else begin
            if (divisor == 8'b0) begin
                quotient <= 8'b0;
                remainder <= 8'b0;
            end else begin
                quotient <= dividend / divisor;
                remainder <= dividend % divisor;
            end
        end
    end
endmodule