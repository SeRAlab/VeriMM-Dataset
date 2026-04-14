module SRAM_Cell (
    input [7:0] data_in,
    input write_enable,
    input clock,
    output reg [7:0] data_out
);

always @(posedge clock) begin
    if (write_enable) begin
        data_out <= data_in; // Write data to SRAM if write_enable is high
    end
end

endmodule