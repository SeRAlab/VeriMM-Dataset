module dma_controller (
    input wire clk,
    input wire reset,
    input wire channel_select, // 0 for channel 0, 1 for channel 1
    input wire read_enable,
    input wire [7:0] data_channel_0, // 8-bit data input for channel 0
    input wire [7:0] data_channel_1, // 8-bit data input for channel 1
    output reg [7:0] data_out // 8-bit output data
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        data_out <= 8'b0;
    end else if (read_enable) begin
        case (channel_select)
            1'b0: data_out <= data_channel_0; // Select channel 0
            1'b1: data_out <= data_channel_1; // Select channel 1
        endcase
    end
end

endmodule