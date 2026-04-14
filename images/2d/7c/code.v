module dma_controller (
    input clk,
    input rst,
    input start,
    input [7:0] src_addr,
    input [7:0] dest_addr,
    input [7:0] transfer_size,
    output reg done
);
    reg [7:0] current_size;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            done <= 0;
            current_size <= 0;
        end else if (start && current_size == 0) begin
            current_size <= transfer_size;
            done <= 0;
        end else if (current_size > 0) begin
            current_size <= current_size - 1;
        end else if (current_size == 0) begin
            done <= 1;
        end
    end
endmodule