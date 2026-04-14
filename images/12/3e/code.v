module dma_controller (
    input wire clk,
    input wire [3:0] req,    // Request lines from 4 channels
    output reg [3:0] grant   // Grant lines for 4 channels
);
    reg [1:0] current_channel; // To track which channel to grant next

    always @(posedge clk) begin
        if (req != 4'b0000) begin // If any request is active
            // Grant access to the first channel that is requested
            case (current_channel)
                2'b00: if (req[0]) begin grant <= 4'b0001; current_channel <= 2'b00; end
                        else if (req[1]) begin grant <= 4'b0010; current_channel <= 2'b01; end
                        else if (req[2]) begin grant <= 4'b0100; current_channel <= 2'b10; end
                        else if (req[3]) begin grant <= 4'b1000; current_channel <= 2'b11; end
                2'b01: if (req[1]) begin grant <= 4'b0010; current_channel <= 2'b01; end
                        else if (req[2]) begin grant <= 4'b0100; current_channel <= 2'b10; end
                        else if (req[3]) begin grant <= 4'b1000; current_channel <= 2'b11; end
                        else if (req[0]) begin grant <= 4'b0001; current_channel <= 2'b00; end
                2'b10: if (req[2]) begin grant <= 4'b0100; current_channel <= 2'b10; end
                        else if (req[3]) begin grant <= 4'b1000; current_channel <= 2'b11; end
                        else if (req[0]) begin grant <= 4'b0001; current_channel <= 2'b00; end
                        else if (req[1]) begin grant <= 4'b0010; current_channel <= 2'b01; end
                2'b11: if (req[3]) begin grant <= 4'b1000; current_channel <= 2'b11; end
                        else if (req[0]) begin grant <= 4'b0001; current_channel <= 2'b00; end
                        else if (req[1]) begin grant <= 4'b0010; current_channel <= 2'b01; end
                        else if (req[2]) begin grant <= 4'b0100; current_channel <= 2'b10; end
            endcase
        end else begin
            grant <= 4'b0000; // No requests, no grants
        end
    end
endmodule