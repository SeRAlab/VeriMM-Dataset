module dma_controller (
    input clk,
    input reset,
    input start,
    input [7:0] src_addr,      // Source address
    input [7:0] dest_addr,     // Destination address
    input [7:0] data_in,       // Data input to be transferred
    output reg [7:0] data_out,  // Data output transferred
    output reg busy,           // Indicates if DMA is busy
    output reg done            // Transfer completion signal
);
    parameter NUM_TRANSFERS = 5;  // Number of transfers
    reg [2:0] transfer_count;       // Transfer counter

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            busy <= 0;
            done <= 0;
            transfer_count <= 0;
            data_out <= 0;
        end else if (start && !busy) begin
            busy <= 1;
            transfer_count <= 0;
            done <= 0;
        end else if (busy) begin
            if (transfer_count < NUM_TRANSFERS) begin
                data_out <= data_in;         // Transfer data
                transfer_count <= transfer_count + 1; // Increment counter
            end else begin
                busy <= 0;                   // Transfer completed
                done <= 1;
            end
        end
    end
endmodule