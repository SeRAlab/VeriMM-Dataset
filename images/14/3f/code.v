module dram_cell (
    input wire D,        // Data input
    input wire WL,       // Wordline
    input wire RESET,    // Reset signal
    output reg BL        // Bitline output
);
    reg stored_bit;

    always @(posedge WL or posedge RESET) begin
        if (RESET) begin
            stored_bit <= 1'b0; // Reset the stored bit to 0
        end else begin
            stored_bit <= D;     // Write data to the stored bit
        end
    end

    always @(*) begin
        BL = stored_bit;         // Output the stored bit on the bitline
    end
endmodule