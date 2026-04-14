module dma_controller (
    input clk,
    input reset,
    input start_channel1,
    input start_channel2,
    input [7:0] address_channel1,
    input [7:0] address_channel2,
    input [15:0] data_in_channel1,
    input [15:0] data_in_channel2,
    output reg [15:0] data_out,
    output reg channel_busy
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 16'b0;
            channel_busy <= 1'b0;
        end else begin
            if (start_channel1) begin
                data_out <= data_in_channel1;
                channel_busy <= 1'b1;
            end else if (start_channel2) begin
                data_out <= data_in_channel2;
                channel_busy <= 1'b1;
            end else begin
                channel_busy <= 1'b0;
            end
        end
    end
endmodule