module divider (
    input clk,
    input reset,
    input [3:0] dividend,
    input [3:0] divisor,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg done
);
    reg [3:0] count;
    reg [3:0] temp_dividend;
    reg [3:0] temp_quotient;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            quotient <= 4'b0000;
            remainder <= 4'b0000;
            temp_dividend <= 4'b0000;
            temp_quotient <= 4'b0000;
            count <= 4'b0000;
            done <= 0;
        end else begin
            if (count < 4) begin
                if (count == 0) begin
                    temp_dividend <= dividend;
                    temp_quotient <= 4'b0000;
                    if (divisor == 4'b0000) begin
                        quotient <= 4'b0000;
                        remainder <= 4'b0000;
                        done <= 1;
                        count <= 4; // Go to done state
                    end
                end else begin
                    temp_dividend = {temp_dividend[2:0], 1'b0};  // Shift left
                    temp_quotient = {temp_quotient[2:0], 1'b0};  // Shift left
                    if (temp_dividend >= divisor) begin
                        temp_dividend = temp_dividend - divisor;
                        temp_quotient[0] = 1'b1; // Set least significant bit of quotient
                    end                    
                end
                count <= count + 1;
            end else if (count == 4) begin
                quotient <= temp_quotient;
                remainder <= temp_dividend;
                done <= 1; // Division done
            end
        end
    end
endmodule