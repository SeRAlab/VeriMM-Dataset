module dram_cell (
    input wire clk,
    input wire write_enable,
    input wire data_in,
    output reg data_out
);

always @(posedge clk) begin
    if (write_enable) begin
        data_out <= data_in; // Store data when writing is enabled
    end
    // If write_enable is low, data_out retains its value
end

endmodule