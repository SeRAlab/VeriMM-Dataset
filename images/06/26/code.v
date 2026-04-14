module dram_cell (
    input wire clk,
    input wire write_enable,
    input wire read_enable,
    input wire data_in,
    output reg data_out
);

always @(posedge clk) begin
    if (write_enable) begin
        data_out <= data_in; // Store data when write_enable is high
    end
end

always @(posedge clk) begin
    if (read_enable) begin
        // Output the stored data when read_enable is high
        // No additional action needed, data_out retains its last value
    end
end

endmodule