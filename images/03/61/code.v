module dram_cell (
    input wire clk,
    input wire write_enable,
    input wire read_enable,
    input wire data_in,
    output reg data_out
);
    reg stored_value;

    always @(posedge clk) begin
        if (write_enable) begin
            stored_value <= data_in; // Store data in the cell
        end
        if (read_enable) begin
            data_out <= stored_value; // Output the stored data
        end
    end
endmodule