module SRAM_Cell (
    input wire data_in,
    input wire write_enable,
    input wire read_enable,
    output reg data_out
);

reg stored_value;

always @(posedge write_enable) begin
    stored_value <= data_in; // Store data when write_enable is high
end

always @(posedge read_enable) begin
    data_out <= stored_value; // Output stored value when read_enable is high
end

endmodule