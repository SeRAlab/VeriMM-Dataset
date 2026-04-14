module sram_cell (
    input wire data_in,
    input wire read_enable,
    input wire write_enable,
    input wire clk,
    output reg data_out
);

reg stored_value;

always @(posedge clk) begin
    if (write_enable) begin
        stored_value <= data_in;
    end
    if (read_enable) begin
        data_out <= stored_value;
    end
end

endmodule