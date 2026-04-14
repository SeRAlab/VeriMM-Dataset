module dma_controller (
    input clk,
    input [3:0] req,
    output reg [3:0] grant
);

always @(posedge clk) begin
    grant <= 4'b0000; // Reset grant
    if (req[0]) grant[0] <= 1'b1;
    else if (req[1]) grant[1] <= 1'b1;
    else if (req[2]) grant[2] <= 1'b1;
    else if (req[3]) grant[3] <= 1'b1;
end

endmodule