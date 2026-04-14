module dma_controller (
    input clk,
    input reset,
    input req1, // Request signal for channel 1
    input req2, // Request signal for channel 2
    output reg ack1, // Acknowledge signal for channel 1
    output reg ack2, // Acknowledge signal for channel 2
    output reg [7:0] data_bus // Data bus for output
);

reg [7:0] data_channel1; // Data for channel 1
reg [7:0] data_channel2; // Data for channel 2

always @(posedge clk or posedge reset) begin
    if (reset) begin
        ack1 <= 0;
        ack2 <= 0;
        data_bus <= 8'b0;
    end else begin
        if (req1) begin
            ack1 <= 1; // Acknowledge channel 1
            data_bus <= data_channel1; // Output data from channel 1
        end else if (req2) begin
            ack2 <= 1; // Acknowledge channel 2
            data_bus <= data_channel2; // Output data from channel 2
        end else begin
            ack1 <= 0;
            ack2 <= 0;
        end
    end
end

endmodule