module eeprom_cell (
    input wire clk,
    input wire rst,
    input wire we,
    input wire re,
    input wire d_in,
    output reg d_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        d_out <= 1'b0; // Reset the cell to 0
    end else if (we) begin
        d_out <= d_in; // Write new data to the cell
    end
end

endmodule