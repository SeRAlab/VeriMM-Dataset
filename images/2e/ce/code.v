module dram_cell (
    input wire clk,
    input wire write_enable,
    input wire refresh,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] memory;

    always @(posedge clk) begin
        if (write_enable) begin
            memory <= data_in; // Write data to memory
        end
        else if (refresh) begin
            // Refresh logic (for simplicity, keep it the same)
            memory <= memory; // In real designs, refresh would affect the contents
        end
    end

    always @(negedge clk) begin
        if (!write_enable) begin
            data_out <= memory; // Read data from memory
        end
    end
endmodule