module high_bit_counter(
    input clk,
    input reset,
    input start,
    input [7:0] data_in,
    output reg [3:0] high_bit_count,
    output reg done
);
    reg [3:0] count;
    reg [7:0] data;
    reg counting;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            high_bit_count <= 4'd0;
            done <= 1'b0;
            count <= 4'd0;
            data <= 8'd0;
            counting <= 1'b0;
        end else if (start && !counting) begin
            data <= data_in;
            count <= 4'd0;
            counting <= 1'b1;
            done <= 1'b0;
        end else if (counting) begin
            if (data != 8'd0) begin
                count <= count + (data[0] ? 4'd1 : 4'd0);
                data <= data >> 1;
            end else begin
                high_bit_count <= count;
                counting <= 1'b0;
                done <= 1'b1;
            end
        end
    end
endmodule