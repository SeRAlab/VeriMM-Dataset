module dma_controller(
    input clk,
    input reset,
    input [3:0] request, // 4-channel request signals
    output reg [3:0] grant // 4-channel grant signals
);
    reg [1:0] current_channel; // to select the channel

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            grant <= 4'b0000; // no channel is granted
            current_channel <= 2'b00; // start from channel 0
        end else begin
            // Check requests and grant access to the first active channel
            if (request != 4'b0000) begin
                grant <= 4'b0000; // reset grant
                if (request[current_channel]) begin
                    grant[current_channel] <= 1; // grant current channel
                end else begin
                    // Move to the next channel
                    current_channel <= (current_channel + 1) % 4;
                    grant[current_channel] <= request[current_channel]; // grant next active channel
                end
            end else begin
                grant <= 4'b0000; // no requests, no grants
            end
        end
    end
endmodule