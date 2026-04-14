module dram_cell (
    input wire data_in,
    input wire write_enable,
    output reg data_out
);
    always @(posedge write_enable or negedge write_enable) begin
        if (write_enable)
            data_out <= data_in; // Store data
        // Output retained data when write_enable is low
    end
endmodule