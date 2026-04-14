module dma_controller(
    input clk,
    input reset,
    input enable,
    input [2:0] channel_select,
    output reg [7:0] data_out,
    output reg [2:0] active_channel
);
    reg [7:0] channel_data [0:7]; // Data for each channel

    // Initialize channel data for simulation
    initial begin
        channel_data[0] = 8'hAA; // Data for channel 0
        channel_data[1] = 8'hBB; // Data for channel 1
        channel_data[2] = 8'hCC; // Data for channel 2
        channel_data[3] = 8'hDD; // Data for channel 3
        channel_data[4] = 8'hEE; // Data for channel 4
        channel_data[5] = 8'hFF; // Data for channel 5
        channel_data[6] = 8'h11; // Data for channel 6
        channel_data[7] = 8'h22; // Data for channel 7
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 8'h00;
            active_channel <= 3'b000;
        end else if (enable) begin
            active_channel <= channel_select;
            data_out <= channel_data[channel_select];
        end
    end
endmodule