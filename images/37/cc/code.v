module dma_controller (
    input clk,
    input rst,
    input [3:0] request,  // DMA request from 4 channels
    output reg [1:0] active_channel, // Indicates the active channel (0-3)
    output reg transfer_active // Indicates if transfer is currently active
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            active_channel <= 2'b00;
            transfer_active <= 1'b0;
        end else begin
            if (request != 4'b0000) begin
                // Check for the highest priority channel (Lowest index)
                if (request[0]) begin
                    active_channel <= 2'b00;
                    transfer_active <= 1'b1;
                end else if (request[1]) begin
                    active_channel <= 2'b01;
                    transfer_active <= 1'b1;
                end else if (request[2]) begin
                    active_channel <= 2'b10;
                    transfer_active <= 1'b1;
                end else if (request[3]) begin
                    active_channel <= 2'b11;
                    transfer_active <= 1'b1;
                end
            end else begin
                transfer_active <= 1'b0; // No active transfer if no request
            end
        end
    end
endmodule