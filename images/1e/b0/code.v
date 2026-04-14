module flash_memory (
    input clk,
    input write_en,
    input erase_en,
    input data_in,
    output reg data_out
);

always @(posedge clk) begin
    if (erase_en) begin
        data_out <= 0; // Erase operation
    end else if (write_en) begin
        data_out <= data_in; // Write operation
    end
    // Read operation is implicit since data_out reflects stored data
end

endmodule