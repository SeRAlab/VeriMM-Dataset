module dma_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] src_addr,
    input wire [7:0] dst_addr,
    input wire [15:0] data,
    output reg done,
    output reg [15:0] mem
);
    reg [7:0] current_src;
    reg [7:0] current_dst;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            done <= 0;
            current_src <= 0;
            current_dst <= 0;
            mem <= 16'b0;
        end else if (start) begin
            current_src <= src_addr;
            current_dst <= dst_addr;
            mem <= data;
            done <= 1;
        end else begin
            done <= 0;
        end
    end
endmodule