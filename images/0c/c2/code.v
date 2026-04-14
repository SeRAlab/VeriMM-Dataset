module dma_controller (
    input wire clk,
    input wire rst,
    input wire [1:0] select,
    input wire valid,
    output reg [3:0] channel_ack
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            channel_ack <= 4'b0000;
        end else if (valid) begin
            channel_ack <= (1 << select);
        end else begin
            channel_ack <= 4'b0000;
        end
    end
endmodule