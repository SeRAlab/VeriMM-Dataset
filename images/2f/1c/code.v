module dram_cell (
    input wire clk,
    input wire we,  // Write enable
    input wire data,  // Data to write
    output reg stored_value  // Value stored in the DRAM
);
    always @(posedge clk) begin
        if (we) begin
            stored_value <= data;  // Store data on write enable
        end
    end
endmodule