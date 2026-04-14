module dma_controller (
    input wire clk,
    input wire reset,
    input wire req_channel1,
    input wire req_channel2,
    output reg ack_channel1,
    output reg ack_channel2,
    output reg [7:0] data_out,
    output reg [15:0] address_out
);
    reg current_channel; // 0 for channel1, 1 for channel2
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ack_channel1 <= 0;
            ack_channel2 <= 0;
            current_channel <= 0;
            data_out <= 8'b0;
            address_out <= 16'b0;
        end else begin
            if (req_channel1 && !ack_channel1) begin
                current_channel <= 0;
                data_out <= // provide data from memory for channel 1
                address_out <= // provide address for channel 1
                ack_channel1 <= 1;
                ack_channel2 <= 0;
            end else if (req_channel2 && !ack_channel2) begin
                current_channel <= 1;
                data_out <= // provide data from memory for channel 2
                address_out <= // provide address for channel 2
                ack_channel2 <= 1;
                ack_channel1 <= 0;
            end else begin
                ack_channel1 <= 0;
                ack_channel2 <= 0;
            end
        end
    end
endmodule