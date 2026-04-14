module dma_controller (
    input clk,
    input reset,
    input start,
    input [2:0] channel_select,
    input [31:0] src_address,
    input [31:0] dst_address,
    input [31:0] data_in,
    output reg [31:0] data_out,
    output reg transfer_complete
);
    reg [31:0] memory [0:7]; // Simulated memory for each channel
    reg [2:0] current_channel;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            transfer_complete <= 0;
            current_channel <= 3'b000;
            data_out <= 32'b0;
        end else if (start) begin
            current_channel <= channel_select;
            memory[current_channel] <= data_in; // Simulate data transfer
            data_out <= memory[current_channel]; // Output the transferred data
            transfer_complete <= 1; // Signal that the transfer is complete
        end else begin
            transfer_complete <= 0; // Reset transfer complete signal
        end
    end
endmodule