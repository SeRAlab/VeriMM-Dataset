module restoring_divider (
    input clk,
    input start,
    input [4:0] dividend,
    input [2:0] divisor,
    output reg [1:0] quotient,
    output reg [2:0] remainder,
    output reg done
);
    reg [4:0] current_dividend;
    reg [2:0] current_divisor;
    reg [1:0] count;

    always @(posedge clk) begin
        if (start) begin
            current_dividend <= dividend;
            current_divisor <= divisor;
            quotient <= 2'b00;
            remainder <= 3'b000;
            count <= 2'b00;
            done <= 0;
        end else if (count < 2'b10) begin
            // Perform restoring division
            remainder <= {remainder[2:0], current_dividend[4]};
            current_dividend <= {current_dividend[3:0], 1'b0}; // Shift left
            if (remainder >= current_divisor) begin
                remainder <= remainder - current_divisor; // Subtract divisor
                quotient[count] <= 1; // Set quotient bit
            end
            count <= count + 1;
        end else begin
            done <= 1; // Division complete
        end
    end
endmodule