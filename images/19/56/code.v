module divider_4bit (
    input [3:0] dividend,
    input [3:0] divisor,
    input clk,
    input start,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg done
);
    always @(posedge clk) begin
        if(start) begin
            if(divisor != 0) begin
                quotient <= dividend / divisor;
                remainder <= dividend % divisor;
                done <= 1;
            end else begin
                quotient <= 4'b0000; // Handle divide by zero
                remainder <= 4'b0000;
                done <= 1;
            end
        end else begin
            done <= 0;
        end
    end
endmodule