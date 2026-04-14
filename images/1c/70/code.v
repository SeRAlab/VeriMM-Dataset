module dram_cell (
    input wire data_in,
    input wire write_enable,
    input wire reset,
    output reg data_out
);

always @(posedge write_enable or posedge reset) begin
    if (reset) begin
        data_out <= 1'b0; // Reset the cell to 0
    end else begin
        data_out <= data_in; // Store the input data
    end
end

endmodule