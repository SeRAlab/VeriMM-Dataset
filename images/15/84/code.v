module dma_controller (
    input wire clk,
    input wire rst,
    input wire enable,
    input wire [1:0] channel_select, // 2-bit channel select (00 for channel 0, 01 for channel 1)
    input wire [23:0] src_addr, // Source address for data transfer
    input wire [23:0] dest_addr, // Destination address for data transfer
    input wire transfer_request, // Request to start transfer
    output reg transfer_complete // Indicate transfer completion
);
    reg [1:0] current_channel;
    reg [23:0] data_buffer; // Temporary buffer for data transfer
    reg transferring; // Indicates if a transfer is in progress

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            transfer_complete <= 0;
            current_channel <= 0;
            transferring <= 0;
        end else begin
            if (enable && transfer_request && !transferring) begin
                current_channel <= channel_select;
                transferring <= 1;
                // Simulate data transfer (in a real system, this would involve memory operations)
                data_buffer <= (current_channel == 2'b00) ? src_addr : dest_addr; // Just for simulation
            end
            
            if (transferring) begin
                // Simulate transfer completion
                transfer_complete <= 1;
                transferring <= 0;
            end else begin
                transfer_complete <= 0;
            end
        end
    end
endmodule