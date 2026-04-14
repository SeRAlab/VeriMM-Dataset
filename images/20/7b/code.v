module dma_controller (
    input wire clk,
    input wire rst,
    input wire req0,
    input wire req1,
    input wire req2,
    input wire req3,
    input wire enable,
    output reg grant,
    output reg busy
);
    reg [1:0] current_channel;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            grant <= 0;
            busy <= 0;
            current_channel <= 0;
        end else if (enable) begin
            if (busy) begin
                // Continue transferring data
                grant <= 1 << current_channel; // Grant access to the current channel
            end else if (req0 || req1 || req2 || req3) begin
                busy <= 1;
                grant <= 1 << current_channel; // Grant access to the current channel
            end
            
            // Round robin logic
            if (grant) begin
                if (current_channel == 3) begin
                    current_channel <= 0; // Wrap around to channel 0
                end else begin
                    current_channel <= current_channel + 1; // Move to next channel
                end
            end else begin
                grant <= 0; // No request, so no grant
            end
        end else begin
            grant <= 0; // Disable the DMA operation
            busy <= 0;
        end
    end
endmodule