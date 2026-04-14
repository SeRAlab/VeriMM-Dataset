module dram_cell (
    input wire clk,
    input wire write_enable,
    input wire read_enable,
    input wire data_in,
    output reg data_out
);
    reg storage;

    always @(posedge clk) begin
        if (write_enable) begin
            storage <= data_in; // Write data to storage
        end
        if (read_enable) begin
            data_out <= storage; // Read data from storage
        end
    end
endmodule