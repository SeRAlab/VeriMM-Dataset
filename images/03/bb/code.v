module dma_controller (
    input wire clk,
    input wire rst,
    input wire [3:0] req,
    output reg [3:0] grant
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            grant <= 4'b0000;
        end else begin
            grant <= 4'b0000; // Reset grant to none
            if (req[0]) grant[0] <= 1'b1;
            else if (req[1]) grant[1] <= 1'b1;
            else if (req[2]) grant[2] <= 1'b1;
            else if (req[3]) grant[3] <= 1'b1;
        end
    end
endmodule