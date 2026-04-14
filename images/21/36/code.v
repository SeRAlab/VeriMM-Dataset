module dma_controller (
    input clk,
    input rst,
    input [3:0] req,       // request signals for each channel
    output reg [3:0] ack,   // acknowledge signals for each channel
    output reg [1:0] bus,    // which channel has access to the bus
    input start             // start signal
);
    reg [1:0] current_channel;
    reg [2:0] cycle_count;  // count for how many cycles to hold the bus
    parameter CYCLE_LIMIT = 4; // fixed number of cycles to hold the bus

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ack <= 4'b0000;
            bus <= 2'b00;
            current_channel <= 2'b00;
            cycle_count <= 3'b000;
        end else if (start) begin
            // Grant access to the channel with the highest priority request
            if (req != 4'b0000) begin
                current_channel <= req[3] ? 2'b11 :
                                   req[2] ? 2'b10 :
                                   req[1] ? 2'b01 :
                                   2'b00;
                ack[current_channel] <= 1'b1; // Acknowledge the current channel
                bus <= current_channel; // Grant bus access
                cycle_count <= CYCLE_LIMIT;
            end
        end else if (cycle_count > 0) begin
            cycle_count <= cycle_count - 1;
            if (cycle_count == 1) begin
                ack[current_channel] <= 1'b0; // Clear ack after cycle limit
                bus <= 2'b00; // Release the bus
            end
        end
    end
endmodule