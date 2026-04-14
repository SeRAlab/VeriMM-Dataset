module eeprom_cell (
    input wire clk,
    input wire reset,
    input wire program,
    input wire erase,
    output reg data
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        data <= 0; // Reset the cell to 0
    end else if (program) begin
        data <= 1; // Program the cell to 1
    end else if (erase) begin
        data <= 0; // Erase the cell to 0
    end
end

endmodule