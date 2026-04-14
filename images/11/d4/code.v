module dma_controller (
    input wire clk,
    input wire reset,
    input wire [3:0] request, // 1 for each channel request
    output reg [1:0] grant // 2-bit output to indicate the granted channel
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            grant <= 2'b00; // No channel granted on reset
        end else begin
            case (request)
                4'b0001: grant <= 2'd0; // Channel 0
                4'b0010: grant <= 2'd1; // Channel 1
                4'b0100: grant <= 2'd2; // Channel 2
                4'b1000: grant <= 2'd3; // Channel 3
                4'b0011: grant <= 2'd0; // Channel 0 & 1, grant 0
                4'b0101: grant <= 2'd0; // Channel 0 & 2, grant 0
                4'b1001: grant <= 2'd0; // Channel 0 & 3, grant 0
                4'b0110: grant <= 2'd1; // Channel 1 & 2, grant 1
                4'b1010: grant <= 2'd2; // Channel 2 & 3, grant 2
                4'b1100: grant <= 2'd3; // Channel 3 & 0, grant 3
                default: grant <= 2'b00; // Default case
            endcase
        end
    end
endmodule