module dma_controller(
    input clk,
    input reset,
    input [3:0] request,   // 4-channel requests
    output reg [3:0] grant  // 4-channel grants
);
    reg [1:0] current_channel;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            grant <= 4'b0000;
            current_channel <= 2'b00;
        end else begin
            // Round-robin scheduling
            grant <= 4'b0000; // Clear grants
            if (request[current_channel]) begin
                grant[current_channel] <= 1'b1; // Grant access to current channel
            end
            
            current_channel <= current_channel + 1; // Move to the next channel
            if (current_channel == 2'b11) current_channel <= 2'b00; // Wrap around
        end
    end
endmodule