module dma_controller (
    input wire clk,
    input wire reset,
    input wire [3:0] req,  // Request lines for Channel 0 to Channel 3
    output reg [3:0] ack,   // Acknowledge lines for Channel 0 to Channel 3
    output reg [1:0] ctrl   // Control signal for the granted channel
);

    reg [1:0] curr_channel;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ack <= 4'b0000;
            curr_channel <= 2'b00;
        end else begin
            ack <= 4'b0000; // Reset all ack lines
            if (req[3]) begin
                curr_channel <= 2'b11; // Channel 3
            end else if (req[2]) begin
                curr_channel <= 2'b10; // Channel 2
            end else if (req[1]) begin
                curr_channel <= 2'b01; // Channel 1
            end else if (req[0]) begin
                curr_channel <= 2'b00; // Channel 0
            end
            ack[curr_channel] <= 1; // Acknowledge the current channel
        end
    end
    
    always @(*) begin
        ctrl = curr_channel; // Output the control signal
    end
endmodule