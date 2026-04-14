module divider_8bit (
    input clk,
    input reset,
    input [7:0] dividend,
    input [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg done
);
    reg [7:0] count;
    reg [15:0] temp_dividend;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            quotient <= 8'b0;
            remainder <= 8'b0;
            done <= 0;
            count <= 8'b0;
        end else begin
            if (count < 8) begin
                temp_dividend = {remainder, dividend[count]};
                if (temp_dividend >= divisor) begin
                    temp_dividend = temp_dividend - divisor;
                    remainder <= temp_dividend[7:0];
                    quotient <= quotient | (1 << (7 - count));
                end else begin
                    remainder <= temp_dividend[7:0];
                end
                count <= count + 1;
            end else begin
                done <= 1;
            end
        end
    end
endmodule