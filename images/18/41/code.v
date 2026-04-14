module DRAM_Cell (
    input wire clk,
    input wire wl,  // Word line
    input wire d,   // Data input
    output reg q    // Data output
);
    reg stored_bit;

    always @(posedge clk) begin
        if (wl) begin
            stored_bit <= d; // Write data to the cell
        end
    end

    always @(negedge clk) begin
        if (!wl) begin
            q <= stored_bit; // Read data from the cell
        end
    end
endmodule