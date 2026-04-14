module restoring_divider (
    input clk,
    input reset,
    input [N-1:0] dividend,
    input [M-1:0] divisor,
    output reg [N-1:0] quotient,
    output reg [M-1:0] remainder
);
    parameter N = 8; // Bit width of dividend
    parameter M = 4; // Bit width of divisor
    reg [N-1:0] temp_dividend;
    reg [M-1:0] temp_divisor;
    reg [N-1:0] temp_quotient;
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            quotient <= 0;
            remainder <= 0;
            temp_dividend <= 0;
            temp_divisor <= 0;
            temp_quotient <= 0;
        end else begin
            temp_dividend <= dividend;
            temp_divisor <= divisor;
            temp_quotient <= 0;

            for (i = 0; i < N; i = i + 1) begin
                temp_quotient = {temp_quotient[N-2:0], temp_dividend[N-1]};
                temp_dividend = {temp_dividend[N-2:0], 1'b0}; 
                
                if (temp_dividend >= temp_divisor) begin
                    temp_dividend = temp_dividend - temp_divisor;
                    temp_quotient[N-1] = 1;
                end else begin
                    temp_quotient[N-1] = 0;
                end
            end
            
            quotient <= temp_quotient;
            remainder <= temp_dividend;
        end
    end
endmodule