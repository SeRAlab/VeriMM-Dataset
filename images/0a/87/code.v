module dma_controller (
    input wire clk,
    input wire rst_n,
    input wire [2:0] channel_sel,
    input wire control, // 1 for write, 0 for read
    input wire enable,
    output reg transfer_complete
);

reg [2:0] current_channel;

// Sequential logic for DMA controller
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        transfer_complete <= 0;
        current_channel <= 3'b000;
    end else if (enable) begin
        current_channel <= channel_sel;
        // Simulate data transfer operation
        transfer_complete <= 1; // Indicating transfer is complete
    end else begin
        transfer_complete <= 0;
    end
end

endmodule