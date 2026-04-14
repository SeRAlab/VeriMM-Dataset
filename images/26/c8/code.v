module dma_controller (
    input clk,
    input reset,
    input req1,
    input req2,
    output reg grant1,
    output reg grant2,
    output reg [7:0] data
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            grant1 <= 0;
            grant2 <= 0;
            data <= 8'b0;
        end else begin
            if (req1) begin
                grant1 <= 1;
                grant2 <= 0;
                data <= 8'hAA; // Example data for Channel 1
            end else if (req2) begin
                grant1 <= 0;
                grant2 <= 1;
                data <= 8'hBB; // Example data for Channel 2
            end else begin
                grant1 <= 0;
                grant2 <= 0;
                data <= 8'b0;
            end
        end
    end
endmodule