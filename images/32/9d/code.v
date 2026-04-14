module DWT_Haar (
    input wire clk,
    input wire [3:0] x, // 4-bit input
    input wire start,
    output reg [3:0] approximation,
    output reg [3:0] detail,
    output reg valid
);
    reg [3:0] x0, x1, x2, x3;

    always @(posedge clk) begin
        if (start) begin
            x0 <= x;
            valid <= 0; // Set valid low until calculation is done
        end
        else begin
            x1 <= x0; // Store the input
            approximation <= (x1 + x1) >> 1; // Approximation (average)
            detail <= (x1 - x1) >> 1; // Detail (difference)
            valid <= 1; // Set valid high after calculation
        end
    end
endmodule