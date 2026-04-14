module dma_controller (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [7:0] src_addr,
    input wire [7:0] dst_addr,
    input wire [7:0] byte_count,
    output reg done
);
    reg [7:0] current_count;
    reg [7:0] current_src;
    reg [7:0] current_dst;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_count <= 0;
            current_src <= 0;
            current_dst <= 0;
            done <= 0;
        end else if (start) begin
            current_count <= byte_count;
            current_src <= src_addr;
            current_dst <= dst_addr;
            done <= 0;
        end else if (current_count > 0) begin
            // Simulate data transfer
            current_count <= current_count - 1;
            current_src <= current_src + 1; // Move to next byte in source
            current_dst <= current_dst + 1; // Move to next byte in destination
        end else if (current_count == 0) begin
            done <= 1; // Transfer complete
        end
    end
endmodule