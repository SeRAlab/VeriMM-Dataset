module sram_cell (
    input wire data_in,
    input wire write_enable,
    input wire read_enable,
    output reg data_out
);
    reg stored_value;

    always @(posedge write_enable) begin
        stored_value <= data_in; // Write operation
    end

    always @(posedge read_enable) begin
        data_out <= stored_value; // Read operation
    end
endmodule