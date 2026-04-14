module dma_controller (
    input wire clk,
    input wire reset,
    input wire [3:0] request, // Request signals for 4 channels
    output reg [1:0] active_channel // Active channel output
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            active_channel <= 2'b00; // Reset to channel 0
        end else begin
            case (request)
                4'b0001: active_channel <= 2'b00; // Channel 0 active
                4'b0010: active_channel <= 2'b01; // Channel 1 active
                4'b0100: active_channel <= 2'b10; // Channel 2 active
                4'b1000: active_channel <= 2'b11; // Channel 3 active
                4'b0011: active_channel <= 2'b00; // Channel 0 active (priority)
                4'b0110: active_channel <= 2'b01; // Channel 1 active (priority)
                4'b1100: active_channel <= 2'b10; // Channel 2 active (priority)
                4'b1110: active_channel <= 2'b00; // Channel 0 active (priority)
                default: active_channel <= 2'b00; // Default to channel 0
            endcase
        end
    end
endmodule