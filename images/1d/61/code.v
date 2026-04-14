module dma_controller (
    input wire request1,
    input wire request2,
    input wire clk,
    input wire reset,
    output reg grant1,
    output reg grant2
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            grant1 <= 0;
            grant2 <= 0;
        end else begin
            if (request1) begin
                grant1 <= 1;
                grant2 <= 0;
            end else if (request2) begin
                grant1 <= 0;
                grant2 <= 1;
            end else begin
                grant1 <= 0;
                grant2 <= 0;
            end
        end
    end
endmodule