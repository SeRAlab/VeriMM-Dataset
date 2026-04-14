module sram_cell (
    input wire data,
    input wire we,
    input wire clk,
    output reg q
);
    always @(posedge clk) begin
        if (we) begin
            q <= data; // Write data to SRAM cell
        end
        // else: do nothing, retain data
    end
endmodule