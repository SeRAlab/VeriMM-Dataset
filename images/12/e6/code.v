module restoring_divider (
    input clk,
    input rst_n,
    input [4:0] dividend,
    input [4:0] divisor,
    output reg [4:0] quotient,
    output reg [4:0] remainder,
    output reg done
);
    reg [4:0] temp_dividend;
    reg [4:0] temp_quotient;
    reg [3:0] count;
    reg [4:0] subtracted;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            quotient <= 5'b0;
            remainder <= 5'b0;
            temp_dividend <= 5'b0;
            temp_quotient <= 5'b0;
            count <= 4'b0;
            done <= 0;
        end else if (count < 5) begin
            if (count == 0) begin
                temp_dividend <= dividend;
                temp_quotient <= 5'b0;
                done <= 0;
            end
            
            subtracted = temp_dividend - divisor;
            if (subtracted[4] == 1) begin // check if negative
                temp_dividend <= temp_dividend << 1; // shift left
                temp_quotient <= temp_quotient << 1; // shift left
                temp_quotient[0] <= 0; // set LSB to 0
            end else begin
                temp_dividend <= subtracted << 1; // shift left after subtraction
                temp_quotient <= (temp_quotient << 1) | 1; // shift left and set LSB to 1
            end
            
            count <= count + 1;
        end else begin
            quotient <= temp_quotient;
            remainder <= temp_dividend;
            done <= 1;
        end
    end
endmodule