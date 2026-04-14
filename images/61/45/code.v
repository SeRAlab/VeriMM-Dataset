module left_shifter(
    input clk,
    input reset,
    input start,
    input [15:0] data_in,
    input [3:0] shift_amount,
    output reg [15:0] data_out,
    output reg done
);
    reg [15:0] data;
    reg [3:0] shift;
    reg shifting;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 16'd0;
            done <= 1'b0;
            shift <= 4'd0;
            data <= 16'd0;
            shifting <= 1'b0;
        end else if (start && !shifting) begin
            data <= data_in;
            shift <= shift_amount;
            shifting <= 1'b1;
            done <= 1'b0;
        end else if (shifting) begin
            data <= data << shift;
            data_out <= data;
            shifting <= 1'b0;
            done <= 1'b1;
        end
    end
endmodule