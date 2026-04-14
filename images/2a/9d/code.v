module dma_controller(
    input clk,
    input rst,
    input [3:0] req,
    input [3:0] ack,
    output reg [3:0] grant
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        grant <= 4'b0000;
    end else begin
        grant <= 4'b0000; // Reset grant
        if (req != 4'b0000) begin
            // Grant the highest priority request
            casez(req)
                4'b1??? : grant <= 4'b0001; // Channel 0
                4'b01?? : grant <= 4'b0010; // Channel 1
                4'b001? : grant <= 4'b0100; // Channel 2
                4'b0001 : grant <= 4'b1000; // Channel 3
                default: grant <= 4'b0000; // No grant
            endcase
        end
    end
end

// Acknowledge logic
always @(posedge clk) begin
    if (ack !== 4'b0000) begin
        grant <= grant & ~ack; // Clear grant for acknowledged channels
    end
end

endmodule