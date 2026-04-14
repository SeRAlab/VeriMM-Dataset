module dma_controller (
    input wire [1:0] channel_select,
    input wire request,
    input wire clk,
    output reg valid,
    output reg [2:0] mem_address
);
    reg [1:0] current_channel;

    always @(posedge clk) begin
        if (request) begin
            valid <= 1'b1;
            current_channel <= channel_select;
            mem_address <= {1'b0, current_channel}; // Assume 3-bit address (0-3)
        end else begin
            valid <= 1'b0;
        end
    end
endmodule