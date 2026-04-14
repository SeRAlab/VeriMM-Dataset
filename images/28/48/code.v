module dma_controller (
    input wire clk,
    input wire rst,
    input wire [3:0] req,      // Request signals for 4 channels
    input wire [1:0] sel,      // 2-bit channel selector
    output reg [3:0] grant     // Grant signals for 4 channels
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            grant <= 4'b0000;  // Reset grants to 0
        end else begin
            grant <= 4'b0000;  // Clear grants
            if (req[sel]) begin
                grant[sel] <= 1'b1;  // Grant the selected channel
            end
        end
    end
endmodule