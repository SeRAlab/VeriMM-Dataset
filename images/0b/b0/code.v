module divider (
    input [7:0] numerator,
    input [7:0] denominator,
    input start,
    input clk,
    input rst,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg error,
    output reg done
);
    reg [7:0] temp_numerator;
    reg [7:0] temp_denominator;
    reg [3:0] count;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 8'b0;
            remainder <= 8'b0;
            error <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else if (start) begin
            if (denominator == 8'b0) begin
                error <= 1'b1;
                done <= 1'b1;
            end else begin
                temp_numerator <= numerator;
                temp_denominator <= denominator;
                quotient <= 8'b0;
                remainder <= numerator;
                count <= 4'b0;
                error <= 1'b0;
                done <= 1'b0;
            end
        end else if (!done) begin
            if (remainder >= temp_denominator) begin
                remainder <= remainder - temp_denominator;
                quotient <= quotient + 1'b1;
            end
            
            count <= count + 1;
            if (count == 4'd8) begin
                done <= 1'b1;
            end
        end
    end
endmodule