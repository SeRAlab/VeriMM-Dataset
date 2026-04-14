module restoring_divider #(parameter WIDTH = 8) (
    input clk,
    input rst,
    input [WIDTH-1:0] dividend,
    input [WIDTH-1:0] divisor,
    output reg [WIDTH-1:0] quotient,
    output reg [WIDTH-1:0] remainder,
    output reg done
);

    reg [WIDTH-1:0] count;
    reg [WIDTH-1:0] temp_dividend;
    reg [WIDTH-1:0] temp_divisor;
    reg [2*WIDTH-1:0] shift_reg;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 0;
            remainder <= 0;
            count <= 0;
            done <= 0;
            temp_dividend <= 0;
            temp_divisor <= 0;
            shift_reg <= 0;
        end else begin
            if (count == 0) begin
                temp_dividend <= dividend;
                temp_divisor <= divisor;
                shift_reg <= {temp_dividend, 1'b0}; // Left shift for new bit
                quotient <= 0;
                done <= 0;
                count <= WIDTH;
            end else if (count > 0) begin
                shift_reg <= {shift_reg[2*WIDTH-2:0], 1'b0}; // Left shift
                if (shift_reg[2*WIDTH-1:WIDTH] >= temp_divisor) begin
                    shift_reg[2*WIDTH-1:WIDTH] <= shift_reg[2*WIDTH-1:WIDTH] - temp_divisor;
                    quotient <= {quotient[WIDTH-2:0], 1'b1}; // Set quotient bit
                end else begin
                    quotient <= {quotient[WIDTH-2:0], 1'b0}; // Clear quotient bit
                end
                count <= count - 1;
            end else if (count == 0) begin
                remainder <= shift_reg[WIDTH-1:0]; // Final remainder
                done <= 1; // Indicate operation done
            end
        end
    end
endmodule