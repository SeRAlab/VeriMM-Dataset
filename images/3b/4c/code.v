module sram_cell (
    input wire data_in,
    input wire we,
    input wire clk,
    output reg data_out
);
    always @(posedge clk) begin
        if (we) begin
            data_out <= data_in;
        end
    end
endmodule