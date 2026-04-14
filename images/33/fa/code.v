module dma_controller (
    input clk,
    input reset,
    input [3:0] request,  // Request lines for 4 channels
    output reg [1:0] grant // Grant signal indicating the active channel (0-3)
);

reg [1:0] current_channel;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_channel <= 2'b00;
        grant <= 2'b00;
    end else begin
        if (request[current_channel]) begin
            grant <= current_channel; // Grant access to the current channel
        end else begin
            // Move to the next channel in round-robin fashion
            current_channel <= (current_channel + 1) % 4;
            // Grant access to the next available channel
            grant <= (request[current_channel] ? current_channel : 
                      (request[(current_channel + 1) % 4] ? (current_channel + 1) % 4 :
                      (request[(current_channel + 2) % 4] ? (current_channel + 2) % 4 :
                      (request[(current_channel + 3) % 4] ? (current_channel + 3) % 4 : current_channel))));
        end
    end
end

endmodule