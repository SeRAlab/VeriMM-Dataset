module dma_controller (
    input clk,
    input rst,
    input [3:0] req,
    output reg [3:0] ack,
    output reg [7:0] data
);
    reg [1:0] current_channel;
    reg [1:0] next_channel;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ack <= 4'b0000;
            current_channel <= 2'b00;
        end else begin
            ack <= 4'b0000; // Reset all acknowledges
            if (req != 4'b0000) begin
                // Prioritize channels based on binary value
                next_channel = (req[3]) ? 2'b11 : 
                               (req[2]) ? 2'b10 : 
                               (req[1]) ? 2'b01 : 
                               (req[0]) ? 2'b00 : 2'b00;
                current_channel <= next_channel;
                ack[current_channel] <= 1'b1; // Acknowledge the current channel
                data <= 8'hFF; // Simulated data transfer
            end
        end
    end
endmodule