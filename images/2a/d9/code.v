module sram_cell (
    input wire we,      // Write enable
    input wire en,      // Enable signal
    input wire d,       // Data input
    output reg q        // Data output
);

    always @(*) begin
        if (!en) begin
            q = 1'bz;    // High impedance when enable is low
        end else if (we) begin
            q = d;       // Write data to the cell
        end else begin
            // Do nothing, retain the previous value of q
        end
    end
endmodule