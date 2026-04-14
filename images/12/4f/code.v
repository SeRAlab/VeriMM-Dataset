module dma_controller (
    input wire [3:0] sel,
    input wire start,
    input wire clk,
    input wire reset,
    output reg [3:0] active_channel
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            active_channel <= 4'b0000;
        end else if (start) begin
            active_channel <= sel;
        end
    end
endmodule