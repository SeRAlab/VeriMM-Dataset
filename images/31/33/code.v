module dma_controller (
    input wire clk,
    input wire reset,
    input wire req1,
    input wire req2,
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
                data <= 8'hAA; // Example data for channel 1
            end else if (req2) begin
                grant1 <= 0;
                grant2 <= 1;
                data <= 8'hBB; // Example data for channel 2
            end else begin
                grant1 <= 0;
                grant2 <= 0;
            end
        end
    end
endmodule