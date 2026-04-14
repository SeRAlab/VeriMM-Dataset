module divider (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [7:0] dividend,
    input wire [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg done
);
    reg [7:0] count;
    reg [15:0] temp_dividend;
    reg [7:0] temp_quotient;
    reg busy;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 8'b0;
            remainder <= 8'b0;
            done <= 0;
            busy <= 0;
            count <= 8'b0;
            temp_dividend <= 16'b0;
            temp_quotient <= 8'b0;
        end else if (start && !busy) begin
            busy <= 1;
            temp_dividend <= {8'b0, dividend}; // Load dividend
            temp_quotient <= 8'b0; // Reset quotient
            count <= 8; // 8 bits to process
            done <= 0;
        end else if (busy) begin
            if (count > 0) begin
                if (temp_dividend >= {8'b0, divisor}) begin
                    temp_dividend <= temp_dividend - {8'b0, divisor}; // Subtract divisor
                    temp_quotient <= (temp_quotient << 1) | 1'b1; // Shift left and set LSB
                end else begin
                    temp_quotient <= temp_quotient << 1; // Shift left
                end
                count <= count - 1;
            end else begin
                quotient <= temp_quotient; // Store the computed quotient
                remainder <= temp_dividend[7:0]; // Store the remainder
                done <= 1; // Indicate that division is done
                busy <= 0; // Ready for the next operation
            end
        end
    end
endmodule