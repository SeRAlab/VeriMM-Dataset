module adder_with_carry(
    input clk,
    input reset,
    input start,
    input [7:0] data1,
    input [7:0] data2,
    input carry_in,
    output reg [7:0] sum,
    output reg carry_out,
    output reg done
);
    reg [8:0] result;
    reg adding;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sum <= 8'd0;
            carry_out <= 1'b0;
            done <= 1'b0;
            adding <= 1'b0;
        end else if (start && !adding) begin
            adding <= 1'b1;
            done <= 1'b0;
        end else if (adding) begin
            result <= data1 + data2 + carry_in;
            sum <= result[7:0];
            carry_out <= result[8];
            adding <= 1'b0;
            done <= 1'b1;
        end
    end
endmodule