module dram_cell (
    input wire data_in,
    input wire write_enable,
    input wire read_enable,
    output reg data_out
);
    reg storage; // Internal storage for the DRAM cell

    always @(posedge write_enable) begin
        storage <= data_in; // Store data when write_enable is high
    end

    always @(posedge read_enable) begin
        data_out <= storage; // Output data when read_enable is high
    end
endmodule