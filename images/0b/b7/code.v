module dma_controller (
    input clk,
    input reset,
    input [3:0] request, // Request signals for 4 channels
    input [3:0] active,  // Active signals for 4 channels
    output reg [3:0] grant // Grant signals for 4 channels
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            grant <= 4'b0000; // Clear grants on reset
        end else begin
            grant <= 4'b0000; // Default grant to none
            case (active)
                4'b0001: if (request[0]) grant[0] <= 1; // Channel 0
                4'b0010: if (request[1]) grant[1] <= 1; // Channel 1
                4'b0100: if (request[2]) grant[2] <= 1; // Channel 2
                4'b1000: if (request[3]) grant[3] <= 1; // Channel 3
                default: grant <= 4'b0000; // No channel active
            endcase
        end
    end
endmodule