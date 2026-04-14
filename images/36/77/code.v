module dma_controller (
    input wire clk,
    input wire reset,
    input wire start_transfer,
    input wire [2:0] channel_select,
    output reg transfer_complete,
    output reg [2:0] current_channel
);

    reg [2:0] next_channel;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_channel <= 3'b000;
            transfer_complete <= 1'b0;
        end else if (start_transfer) begin
            current_channel <= channel_select;
            transfer_complete <= 1'b0; // Reset transfer complete during transfer
        end else begin
            // Simulate transfer completion
            transfer_complete <= (current_channel == channel_select) ? 1'b1 : 1'b0;
        end
    end
endmodule