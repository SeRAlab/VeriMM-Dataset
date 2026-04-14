module dram_cell (
    input wire data_in,
    input wire write_enable,
    input wire read_enable,
    input wire clk,
    output reg data_out
);

    reg stored_data;

    always @(posedge clk) begin
        if (write_enable) begin
            stored_data <= data_in; // Write data to the DRAM cell
        end
    end

    always @(posedge clk) begin
        if (read_enable) begin
            data_out <= stored_data; // Read data from the DRAM cell
        end
    end

endmodule