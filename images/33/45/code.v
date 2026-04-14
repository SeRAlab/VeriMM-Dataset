module dram_cell (
    input wire D,      // Data input
    input wire WL,     // Word line (control signal)
    output reg BL      // Bit line (output)
);

reg stored_data;      // Internal storage for the DRAM cell

always @(posedge WL) begin
    stored_data <= D; // Latch data when WL is high
end

always @(negedge WL) begin
    BL <= stored_data; // Output the stored data when WL goes low
end

endmodule