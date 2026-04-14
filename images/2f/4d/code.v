module dma_controller (
    input clk,
    input reset,
    input [3:0] req,
    output reg [3:0] grant
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            grant <= 4'b0000;
        end else begin
            grant <= 4'b0000; // Default no grants
            if (req[0]) grant[0] <= 1;
            else if (req[1]) grant[1] <= 1;
            else if (req[2]) grant[2] <= 1;
            else if (req[3]) grant[3] <= 1;
        end
    end
endmodule