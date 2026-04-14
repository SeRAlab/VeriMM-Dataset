module dma_controller (
    input clk,
    input rst,
    input start,
    input [2:0] channel,
    input rw, // read/write: 1 for read, 0 for write
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg done
);

reg [7:0] memory [7:0]; // 8 channels of memory
reg [2:0] current_channel;
reg busy;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        done <= 0;
        busy <= 0;
        current_channel <= 0;
    end else if (start && !busy) begin
        current_channel <= channel;
        busy <= 1;
        done <= 0;
        if (rw) begin
            // Read operation
            data_out <= memory[current_channel];
        end else begin
            // Write operation
            memory[current_channel] <= data_in;
        end
    end else if (busy) begin
        done <= 1; // Operation complete
        busy <= 0; // Ready for the next operation
    end
end

endmodule