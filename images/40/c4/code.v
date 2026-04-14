module dma_controller(
    input wire [3:0] req,
    input wire [3:0] ack,
    input wire clk,
    input wire reset,
    output reg [1:0] active_channel
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        active_channel <= 2'b00; // Reset active channel
    end else begin
        // Grant access to the highest priority request
        case (req)
            4'b0001: active_channel <= 2'b00; // Channel 0
            4'b0010: active_channel <= 2'b01; // Channel 1
            4'b0100: active_channel <= 2'b10; // Channel 2
            4'b1000: active_channel <= 2'b11; // Channel 3
            4'b0011: active_channel <= 2'b00; // Channel 0, priority to 0
            4'b0110: active_channel <= 2'b01; // Channel 1, priority to 1
            4'b1100: active_channel <= 2'b10; // Channel 2, priority to 2
            default: active_channel <= 2'b00; // Default to channel 0
        endcase
    end
end
endmodule