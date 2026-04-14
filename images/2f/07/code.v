module dma_controller(
    input clk,
    input rst,
    input enable,
    input [2:0] channel_select,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg transfer_complete
);
    reg [7:0] memory [7:0]; // 8 channels of memory
    reg [2:0] current_channel;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_channel <= 3'b000;
            transfer_complete <= 1'b0;
        end else if (enable) begin
            current_channel <= channel_select;
            memory[channel_select] <= data_in; // Write data to memory
            data_out <= memory[channel_select]; // Read back data
            transfer_complete <= 1'b1; // Signal that transfer is complete
        end else begin
            transfer_complete <= 1'b0;
        end
    end
endmodule