module restoring_divider (
    input clk,
    input rst,
    input [3:0] dividend,
    input [1:0] divisor,
    output reg [1:0] quotient,
    output reg [1:0] remainder,
    output reg done
);
    reg [3:0] current_dividend;
    reg [1:0] current_quotient;
    reg [1:0] count;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_dividend <= 4'b0;
            current_quotient <= 2'b0;
            count <= 2'b0;
            quotient <= 2'b0;
            remainder <= 2'b0;
            done <= 0;
        end else begin
            if (count < 2) begin
                current_dividend <= {current_dividend[2:0], 1'b0}; // Shift left
                if (current_dividend >= {2'b0, divisor}) begin
                    current_dividend <= current_dividend - {2'b0, divisor}; // Subtract
                    current_quotient <= current_quotient + 1;
                end
                count <= count + 1;
            end else begin
                quotient <= current_quotient;
                remainder <= current_dividend[1:0];
                done <= 1; // Signal that operation is done
            end
        end
    end
endmodule