module sram_cell (
    input wire clk,
    input wire write_enable,
    input wire data_in,
    output reg data_out
);
    always @(posedge clk) begin
        if (write_enable) begin
            data_out <= data_in; // Write data to the SRAM cell
        end
    end
endmodule