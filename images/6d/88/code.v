module subtractor_with_borrow(
    input clk,
    input reset,
    input start,
    input [7:0] data1,
    input [7:0] data2,
    input borrow_in,
    output reg [7:0] difference,
    output reg borrow_out,
    output reg done
);
    reg [8:0] result;
    reg subtracting;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            difference <= 8'd0;
            borrow_out <= 1'b0;
            done <= 1'b0;
            subtracting <= 1'b0;
        end else if (start && !subtracting) begin
            subtracting <= 1'b1;
            done <= 1'b0;
        end else if (subtracting) begin
            result <= {1'b0, data1} - {1'b0, data2} - borrow_in;
            difference <= result[7:0];
            borrow_out <= result[8];
            subtracting <= 1'b0;
            done <= 1'b1;
        end
    end
endmodule