module SRAM_Cell (
    input wire we,       // Write enable
    input wire wl,       // Wordline
    input wire d,        // Data input
    output reg q         // Data output
);

// Internal storage of the SRAM cell
reg storage;

// Always block to handle the storage logic
always @(posedge wl) begin
    if (we) begin
        storage <= d; // Write data to storage if write enable is active
    end
end

// Assign output to storage
always @(*) begin
    q = storage; // Output current storage value
end

endmodule