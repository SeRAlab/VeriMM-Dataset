module dma_controller (
    input wire clk,
    input wire enable,
    input wire [3:0] req,  // Request signals for 4 channels
    output reg [3:0] grant  // Grant signal for the channel with access
);
    reg [1:0] state;
    
    always @(posedge clk) begin
        if (enable) begin
            case (state)
                2'b00: begin
                    // Initial state, check requests
                    if (req != 4'b0000) begin
                        grant <= req;  // Grant access to the requested channel
                        state <= 2'b01; // Move to grant state
                    end
                end
                2'b01: begin
                    // Granting state, hold the grant until next clock
                    if (req == 4'b0000) begin
                        grant <= 4'b0000; // No requests, release grant
                        state <= 2'b00; // Go back to initial state
                    end
                end
            endcase
        end
    end
endmodule