module sram_cell (
    input wire data_in,
    input wire write_enable,
    input wire read_enable,
    output reg data_out
);
    reg stored_bit;

    always @(posedge write_enable) begin
        stored_bit <= data_in; // Write data on write_enable
    end

    always @(posedge read_enable) begin
        data_out <= stored_bit; // Read stored data on read_enable
    end
endmodule