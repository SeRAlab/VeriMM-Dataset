module sram_cell (
    input wire data_in,
    input wire write_enable,
    input wire clock,
    output reg data_out
);

always @(posedge clock) begin
    if (write_enable) begin
        data_out <= data_in;
    end
end

endmodule