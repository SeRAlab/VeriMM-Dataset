module dma_controller (
    input wire clk,
    input wire reset,
    input wire [2:0] channel_select,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg [2:0] active_channel
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 8'b0;
            active_channel <= 3'b000;
        end else begin
            active_channel <= channel_select;
            data_out <= data_in;
        end
    end
endmodule