module dma_controller (
    input clk,
    input reset,
    input req0,
    input req1,
    input req2,
    input req3,
    output reg grant
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            grant <= 0;
        end else begin
            if (req3) grant <= 3; // Channel 3 has highest priority
            else if (req2) grant <= 2;
            else if (req1) grant <= 1;
            else if (req0) grant <= 0;
            else grant <= 0; // No request
        end
    end
endmodule