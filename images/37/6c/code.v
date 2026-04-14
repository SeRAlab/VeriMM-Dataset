module dma_controller(
    input wire clk,
    input wire reset,
    input wire [3:0] req,
    output reg [3:0] grant
);
    reg [1:0] current_channel;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            grant <= 4'b0000;
            current_channel <= 2'b00;
        end else begin
            if (req != 4'b0000) begin
                grant <= 4'b0000; // Clear grant
                grant[current_channel] <= 1; // Grant current channel
                // Move to next channel in round-robin fashion
                current_channel <= (current_channel + 1) % 4;
            end else begin
                grant <= 4'b0000; // No request, no grant
            end
        end
    end
endmodule