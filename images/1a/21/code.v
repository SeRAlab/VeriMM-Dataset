module dma_controller (
    input wire [3:0] req,       // request signals
    input wire [3:0] ack,       // acknowledge signals
    input wire start,           // start signal
    input wire clk,             // clock signal
    input wire reset,           // reset signal
    output reg [3:0] grant      // grant signals
);

reg [3:0] state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        grant <= 4'b0000; // No channel granted
        state <= 4'b0000; // Reset state
    end
    else if (start) begin
        case (req)
            4'b0001: grant <= 4'b0001; // Grant channel 0
            4'b0010: grant <= 4'b0010; // Grant channel 1
            4'b0100: grant <= 4'b0100; // Grant channel 2
            4'b1000: grant <= 4'b1000; // Grant channel 3
            4'b0011: grant <= 4'b0001; // Grant channel 0 (highest priority)
            4'b0110: grant <= 4'b0010; // Grant channel 1 (highest priority)
            4'b1100: grant <= 4'b0100; // Grant channel 2 (highest priority)
            4'b1111: grant <= 4'b0001; // Grant channel 0 (arbitrary)
            default: grant <= 4'b0000; // No channel granted
        endcase
    end
end

endmodule