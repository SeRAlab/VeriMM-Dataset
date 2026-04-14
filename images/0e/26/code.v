module dma_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] src_addr,
    input wire [7:0] dst_addr,
    input wire [7:0] transfer_size,
    output reg busy,
    output reg done
);
    reg [7:0] src_ptr;
    reg [7:0] dst_ptr;
    reg [7:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            busy <= 1'b0;
            done <= 1'b0;
            src_ptr <= 8'b0;
            dst_ptr <= 8'b0;
            count <= 8'b0;
        end else if (start && !busy) begin
            busy <= 1'b1;
            done <= 1'b0;
            src_ptr <= src_addr;
            dst_ptr <= dst_addr;
            count <= transfer_size;
        end else if (busy) begin
            if (count > 0) begin
                // Simulate reading from source and writing to destination
                // In real hardware, you would have memory read/write logic here
                src_ptr <= src_ptr + 1;
                dst_ptr <= dst_ptr + 1;
                count <= count - 1;
            end else begin
                busy <= 1'b0;
                done <= 1'b1;
            end
        end
    end
endmodule