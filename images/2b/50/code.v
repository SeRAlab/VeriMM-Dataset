module sram_cell (
    input wire d,      // Data input
    input wire re,     // Read enable
    input wire we,     // Write enable
    output reg q       // Data output
);
    always @(*) begin
        if (we) begin
            q <= d;     // Write data to the cell
        end
    end

    always @(*) begin
        if (re) begin
            q <= q;     // Read data from the cell
        end
    end
endmodule