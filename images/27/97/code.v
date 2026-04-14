module dram_cell (
    input wire clk,
    input wire we,
    input wire re,
    input wire d,
    output reg q
);
    always @(posedge clk) begin
        if (we) begin
            q <= d; // Store data on write enable
        end
    end

    always @(posedge clk) begin
        if (re) begin
            // Output the stored data
            // Note: No specific action needed here since q is already assigned
        end
    end
endmodule