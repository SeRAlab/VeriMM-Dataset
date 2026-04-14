module dma_controller (
    input wire clk,
    input wire reset,
    input wire req1,
    input wire req2,
    output reg grant1,
    output reg grant2
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            grant1 <= 0;
            grant2 <= 0;
        end else begin
            grant1 <= 0;
            grant2 <= 0;
            if (req1) begin
                grant1 <= 1;
            end else if (req2) begin
                grant2 <= 1;
            end
        end
    end
endmodule