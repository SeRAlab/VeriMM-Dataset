module dma_controller (
    input wire clk,
    input wire reset,
    input wire [3:0] req,      // Request signals from 4 channels
    output reg [3:0] ack,      // Acknowledge signals for 4 channels
    output reg [7:0] data_bus   // Data bus for transferring data
);
    reg [1:0] current_channel; // to track the current channel being serviced
    reg busy;                 // to indicate if a channel is being serviced

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ack <= 4'b0000;
            busy <= 1'b0;
            current_channel <= 2'b00;
        end else begin
            if (!busy) begin
                // Check for active requests and prioritize channels
                if (req[0]) begin
                    current_channel <= 2'b00;
                    busy <= 1'b1;
                end else if (req[1]) begin
                    current_channel <= 2'b01;
                    busy <= 1'b1;
                end else if (req[2]) begin
                    current_channel <= 2'b10;
                    busy <= 1'b1;
                end else if (req[3]) begin
                    current_channel <= 2'b11;
                    busy <= 1'b1;
                end
            end
            // Acknowledge the active channel
            if (busy) begin
                ack <= 4'b0000;
                ack[current_channel] <= 1'b1; // Acknowledge the current channel
                // Simulate data transfer
                data_bus <= current_channel; // Just simulating data transfer with channel number
                busy <= 1'b0; // Mark as done
            end
        end
    end
endmodule