module non_restoring_divider(
    input [7:0] dividend,
    input [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder
);
    reg [15:0] temp_dividend;
    reg [7:0] temp_quotient;
    reg [7:0] temp_remainder;
    
    integer i;
    
    always @* begin
        temp_dividend = {8'b0, dividend}; // Extend dividend with 0s
        temp_quotient = 8'b0;
        temp_remainder = 8'b0;
        
        for (i = 0; i < 8; i = i + 1) begin
            temp_dividend = {temp_dividend[14:0], 1'b0}; // Shift left
            temp_dividend[7:0] = temp_dividend[7:0] - divisor; // Subtract divisor
            
            if (temp_dividend[15] == 1) begin // If negative
                temp_dividend[7:0] = temp_dividend[7:0] + divisor; // Restore
                temp_quotient = {temp_quotient[6:0], 1'b0}; // Append 0
            end else begin // If positive
                temp_quotient = {temp_quotient[6:0], 1'b1}; // Append 1
            end
        end
        
        quotient = temp_quotient;
        remainder = temp_dividend[7:0];
    end
endmodule