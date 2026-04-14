module divider (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [3:0] dividend,
    input wire [3:0] divisor,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg done
);
    reg [3:0] count;
    reg [7:0] temp_dividend;
    reg [3:0] temp_divisor;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 4'b0;
            remainder <= 4'b0;
            done <= 0;
            count <= 4'b0;
        end else if (start) begin
            temp_dividend <= {4'b0, dividend}; // Extend dividend to 8 bits
            temp_divisor <= divisor;
            count <= 4'b0;
            done <= 0;
        end else if (count < 4) begin
            temp_dividend <= {temp_dividend[6:0], 1'b0}; // Shift left
            if (temp_dividend[7:4] >= temp_divisor) begin
                temp_dividend[7:4] = temp_dividend[7:4] - temp_divisor; // Subtract divisor
                quotient[count] = 1'b1;
            end
            count <= count + 1;
        end else begin
            remainder <= temp_dividend[7:4]; // Extract remainder
            done <= 1;
        end
    end
endmodule