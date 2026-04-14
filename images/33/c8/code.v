module dma_controller (
    input wire clk,
    input wire reset,
    input wire [7:0] request,
    output reg [7:0] grant
);
    reg [2:0] current_channel;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            grant <= 8'b0;
            current_channel <= 3'b000;
        end else begin
            if (request != 8'b0) begin
                grant <= 8'b0; // Clear grant
                grant[current_channel] <= 1'b1; // Grant access to current channel
                
                // Move to the next channel in round-robin fashion
                current_channel <= (current_channel + 1) % 8;
            end else begin
                grant <= 8'b0; // No request, no grant
            end
        end
    end
endmodule