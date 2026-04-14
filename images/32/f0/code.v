module dma_controller (
    input wire clk,
    input wire reset,
    input wire [7:0] req,   // 8 request lines for the DMA channels
    output reg [7:0] grant,  // 8 grant lines for the DMA channels
    output reg [7:0] data_out // Data output line
);
    reg [2:0] current_channel; // 3-bit channel index (0 to 7)
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            grant <= 8'b00000000;
            current_channel <= 3'b000;
            data_out <= 8'b00000000;
        end else begin
            // Round-robin grant logic
            grant <= 8'b00000000;
            if (req) begin
                grant[current_channel] <= 1'b1; // Grant current channel
                data_out <= {8{current_channel}}; // Simulate data output
                current_channel <= (current_channel + 1) % 8; // Move to the next channel
            end
        end
    end
endmodule