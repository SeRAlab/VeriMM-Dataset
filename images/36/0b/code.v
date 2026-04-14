module sram_cell (
    input wire [15:0] data_in,
    input wire write_en,
    input wire clk,
    output reg [15:0] data_out
);
    always @(posedge clk) begin
        if (write_en) begin
            data_out <= data_in; // Latch data on write enable
        end
    end
endmodule