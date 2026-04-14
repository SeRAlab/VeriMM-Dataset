module flash_memory_cell (
    input wire data_in,    // Input data to be stored (0 or 1)
    input wire write_en,   // Write enable signal
    input wire read_en,    // Read enable signal
    output reg stored_value // Output stored value
);
    always @(*) begin
        if (write_en) begin
            stored_value = data_in; // Store data on write enable
        end
        // No operation on read enable, just reflect stored_value
    end
endmodule