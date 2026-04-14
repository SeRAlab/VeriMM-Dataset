module dma_controller (
    input wire clk,
    input wire rst,
    input wire [3:0] req,
    output reg [3:0] grant
);
    reg [1:0] current_channel;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            grant <= 4'b0000;
            current_channel <= 2'b00;
        end else begin
            if (req != 4'b0000) begin
                grant <= 4'b0000; // Reset grant
                grant[current_channel] <= 1'b1; // Grant current channel
                current_channel <= (current_channel + 1) % 4; // Round-robin
            end else begin
                grant <= 4'b0000; // No requests
            end
        end
    end
endmodule