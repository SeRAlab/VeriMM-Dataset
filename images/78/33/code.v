module bitwise_and(
    input clk,
    input reset,
    input start,
    input [7:0] data1,
    input [7:0] data2,
    output reg [7:0] result,
    output reg done
);
    reg anding;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            result <= 8'd0;
            done <= 1'b0;
            anding <= 1'b0;
        end else if (start && !anding) begin
            anding <= 1'b1;
            done <= 1'b0;
        end else if (anding) begin
            result <= data1 & data2;
            anding <= 1'b0;
            done <= 1'b1;
        end
    end
endmodule