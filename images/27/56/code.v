module dma_controller(
    input clk,
    input reset,
    input [3:0] request,
    output reg [3:0] grant
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            grant <= 4'b0000;
        end else begin
            grant <= 4'b0000; // Default no grants
            if (request[0]) grant <= 4'b0001; // Channel 0
            else if (request[1]) grant <= 4'b0010; // Channel 1
            else if (request[2]) grant <= 4'b0100; // Channel 2
            else if (request[3]) grant <= 4'b1000; // Channel 3
        end
    end
endmodule