module divider_4bit (
    input wire clk,
    input wire start,
    input wire [3:0] numerator,
    input wire [3:0] denominator,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg done
);
    reg [3:0] temp_numerator;
    reg [3:0] temp_denominator;
    reg [3:0] count; // Count for division steps
    reg state; // 0 for idle, 1 for dividing
    
    always @(posedge clk) begin
        if (start) begin
            temp_numerator <= numerator;
            temp_denominator <= denominator;
            quotient <= 0;
            remainder <= 0;
            count <= 4;
            state <= 1; // start division
            done <= 0;
        end else if (state) begin
            if (count > 0) begin
                if (temp_numerator >= temp_denominator) begin
                    temp_numerator <= temp_numerator - temp_denominator;
                    quotient <= quotient + 1;
                end
                count <= count - 1;
            end else begin
                remainder <= temp_numerator;
                done <= 1; // division done
                state <= 0; // return to idle state
            end
        end
    end
endmodule