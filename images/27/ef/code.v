module restoring_divider(
    input clk,
    input rst,
    input [4:0] dividend,
    input [2:0] divisor,
    output reg [4:0] quotient,
    output reg [2:0] remainder,
    output reg done
);
    reg [4:0] current_dividend;
    reg [4:0] current_quotient;
    reg [2:0] current_remainder;
    reg [2:0] count;
    reg [2:0] divisor_shifted;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_dividend <= 0;
            current_quotient <= 0;
            current_remainder <= 0;
            count <= 0;
            done <= 0;
        end else if (count < 3'd5) begin
            if (count == 0) begin
                current_dividend <= dividend;
                current_quotient <= 0;
                divisor_shifted <= divisor << (4 - count);
            end else begin
                current_dividend <= {current_dividend[3:0], 1'b0}; // Shift left
                divisor_shifted <= divisor << (4 - count);
            end

            if (current_dividend >= divisor_shifted) begin
                current_dividend <= current_dividend - divisor_shifted;
                current_quotient <= current_quotient | (1 << (4 - count));
            end
            
            count <= count + 1;
        end else begin
            quotient <= current_quotient;
            remainder <= current_dividend[2:0];
            done <= 1;
        end
    end
endmodule