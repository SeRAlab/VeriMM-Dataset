module dma_controller(
    input wire clk,
    input wire reset,
    input wire channel1_enable,
    input wire channel2_enable,
    input wire [7:0] data_in,
    output reg [7:0] channel1_data,
    output reg [7:0] channel2_data
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            channel1_data <= 8'b0;
            channel2_data <= 8'b0;
        end else begin
            if (channel1_enable) begin
                channel1_data <= data_in;
            end
            if (channel2_enable) begin
                channel2_data <= data_in;
            end
        end
    end
endmodule