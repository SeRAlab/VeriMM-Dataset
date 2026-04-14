module dma_controller (
    input clk,
    input reset,
    input enable,
    input [3:0] request, // 4 channels request signals
    output reg [1:0] grant // grant signal for the active channel (00, 01, 10, 11)
);

    reg [1:0] current_channel;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_channel <= 2'b00;
            grant <= 2'b00;
        end else if (enable) begin
            if (request[current_channel]) begin
                grant <= current_channel;
            end else begin
                // Round-robin scheduling
                current_channel <= current_channel + 1'b1;
                // If the current channel exceeds 3, wrap around.
                if (current_channel == 2'b11) 
                    current_channel <= 2'b00;
                
                // Check again if the new channel's request is active
                if (request[current_channel])
                    grant <= current_channel;
                else
                    grant <= 2'b00; // No valid request
            end
        end
    end
endmodule