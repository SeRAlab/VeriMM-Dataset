module dma_controller (
    input clk,
    input reset,
    input start,
    input channel_select, // 0 for channel 0, 1 for channel 1
    input [7:0] src_addr,
    input [7:0] dest_addr,
    input [7:0] data,
    output reg busy,
    output reg done
);
    reg [7:0] memory [255:0]; // Memory for data storage
    reg [7:0] src_reg;
    reg [7:0] dest_reg;
    reg [3:0] count;
    reg selected_channel;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            busy <= 0;
            done <= 0;
            count <= 0;
        end else if (start && !busy) begin
            busy <= 1;
            selected_channel <= channel_select;
            src_reg <= src_addr;
            dest_reg <= dest_addr;
            count <= 0; // Start transfer
        end else if (busy) begin
            if (count < 8) begin // Transfer 8 bytes of data
                memory[dest_reg + count] <= memory[src_reg + count];
                count <= count + 1;
            end else begin
                busy <= 0;
                done <= 1; // Transfer complete
            end
        end else begin
            done <= 0; // Reset done signal
        end
    end
endmodule