module sram_cell (
    input wire data_in,
    input wire write_enable,
    input wire read_enable,
    output reg data_out
);
    reg storage; // internal storage for the SRAM cell

    always @(posedge write_enable) begin
        if (write_enable) begin
            storage <= data_in; // Write data to storage
        end
    end

    always @(posedge read_enable) begin
        if (read_enable) begin
            data_out <= storage; // Read data from storage
        end
    end
endmodule