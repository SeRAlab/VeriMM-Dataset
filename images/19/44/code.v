module restoring_divider(
    input clk,
    input reset,
    input [7:0] dividend,
    input [3:0] divisor,
    output reg [7:0] quotient,
    output reg done
);
    reg [7:0] remainder;
    reg [7:0] temp_dividend;
    reg [3:0] count;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            quotient <= 8'b0;
            remainder <= 8'b0;
            temp_dividend <= 8'b0;
            count <= 4'b0;
            done <= 1'b0;
        end else if (count < 8) begin
            temp_dividend = {remainder[6:0], dividend[count]};
            remainder = temp_dividend - {divisor, 4'b0};
            if (remainder[7]) begin
                remainder = temp_dividend;
                quotient[count] = 1'b0;
            end else begin
                quotient[count] = 1'b1;
            end
            count <= count + 1;
        end else begin
            done <= 1'b1;
        end
    end
endmodule