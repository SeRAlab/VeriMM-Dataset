module dma_controller (
    input clk,
    input reset,
    input [2:0] channel_select, // 3-bit channel select for 8 channels
    input start_transfer,       // Signal to start the transfer
    input [7:0] addr,           // Address for data transfer
    input [7:0] data_in,        // Data to be transferred
    output reg [7:0] data_out,  // Data output after transfer
    output reg transfer_complete  // Signal that the transfer is complete
);
    reg [7:0] addr_reg [0:7];   // Address register for each channel
    reg [7:0] data_reg [0:7];   // Data register for each channel
    reg transferring;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            transfer_complete <= 0;
            transferring <= 0;
        end else begin
            if (start_transfer && !transferring) begin
                addr_reg[channel_select] <= addr; // Load the address to the selected channel
                data_reg[channel_select] <= data_in; // Load the data to the selected channel
                transferring <= 1; // Set transferring flag
            end
            
            if (transferring) begin
                data_out <= data_reg[channel_select]; // Transfer data from the selected channel
                transfer_complete <= 1; // Signal that transfer is complete
                transferring <= 0; // Reset transferring flag
            end else begin
                transfer_complete <= 0; // Reset complete signal
            end
        end
    end
endmodule