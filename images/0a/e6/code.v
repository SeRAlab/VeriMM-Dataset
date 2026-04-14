module dma_controller (
    input clk,
    input reset,
    input [3:0] request,
    input ack,
    output reg [3:0] grant,
    output reg [1:0] active_channel
);

    reg [1:0] next_channel;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            grant <= 4'b0000;
            active_channel <= 2'b00;
            next_channel <= 2'b00;
        end else begin
            if (ack) begin
                grant <= 4'b0000; // Deactivate current channel grant
            end
            
            // Find next channel to grant
            next_channel = (active_channel + 1) % 4;
            if (request[next_channel]) begin
                grant[next_channel] <= 1'b1; // Grant access to the next requested channel
                active_channel <= next_channel; // Update active channel
            end else begin
                // Continue searching if the next channel is not requesting
                active_channel <= next_channel;
                if (request[active_channel]) begin
                    grant[active_channel] <= 1'b1; // Grant access if current active channel requests
                end
            end
        end
    end
endmodule