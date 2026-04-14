module dram_cell (
    input clk,
    input we,
    input d,
    output reg q
);
    always @(posedge clk) begin
        if (we) begin
            q <= d; // Write data to the cell
        end
    end
endmodule