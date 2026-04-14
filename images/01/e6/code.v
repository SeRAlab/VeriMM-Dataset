module dma_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [2:0] channel_select,
    input wire [15:0] mem_address,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);

reg [7:0] channels [0:7]; // Memory for 8 channels

always @(posedge clk or posedge reset) begin
    if (reset) begin
        data_out <= 8'b0;
        // Initialize channels to some values (for simulation)
        channels[0] <= 8'd1;
        channels[1] <= 8'd2;
        channels[2] <= 8'd3;
        channels[3] <= 8'd4;
        channels[4] <= 8'd5;
        channels[5] <= 8'd6;
        channels[6] <= 8'd7;
        channels[7] <= 8'd8;
    end else if (start) begin
        data_out <= channels[channel_select]; // Transfer data from selected channel
    end
end

endmodule