module dma_controller (
    input wire clk,
    input wire reset,
    input wire [3:0] req,   // Request signals from four channels
    output reg [3:0] ack,    // Acknowledge signals for each channel
    output reg [3:0] en      // Enable signals for each channel
);

reg [1:0] current_channel;
reg [1:0] next_channel;

// Sequential logic for channel handling
always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_channel <= 2'b00; // Reset to channel 0
        ack <= 4'b0000;
        en <= 4'b0000;
    end else begin
        ack <= 4'b0000; // Default to no acknowledge
        en <= 4'b0000; // Default to no enable
        
        // Check for requests in round-robin order
        case (current_channel)
            2'b00: if (req[0]) begin
                        ack[0] <= 1'b1;
                        en[0] <= 1'b1;
                    end else if (req[1]) begin
                        current_channel <= 2'b01;
                    end else if (req[2]) begin
                        current_channel <= 2'b10;
                    end else if (req[3]) begin
                        current_channel <= 2'b11;
                    end
            2'b01: if (req[1]) begin
                        ack[1] <= 1'b1;
                        en[1] <= 1'b1;
                    end else if (req[2]) begin
                        current_channel <= 2'b10;
                    end else if (req[3]) begin
                        current_channel <= 2'b11;
                    end else if (req[0]) begin
                        current_channel <= 2'b00;
                    end
            2'b10: if (req[2]) begin
                        ack[2] <= 1'b1;
                        en[2] <= 1'b1;
                    end else if (req[3]) begin
                        current_channel <= 2'b11;
                    end else if (req[0]) begin
                        current_channel <= 2'b00;
                    end else if (req[1]) begin
                        current_channel <= 2'b01;
                    end
            2'b11: if (req[3]) begin
                        ack[3] <= 1'b1;
                        en[3] <= 1'b1;
                    end else if (req[0]) begin
                        current_channel <= 2'b00;
                    end else if (req[1]) begin
                        current_channel <= 2'b01;
                    end else if (req[2]) begin
                        current_channel <= 2'b10;
                    end
        endcase
    end
end

endmodule