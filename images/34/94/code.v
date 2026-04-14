module dram_cell (
    input wire clk,
    input wire [3:0] data_in,
    input wire read_enable,
    input wire write_enable,
    output reg [3:0] data_out
);
    reg [3:0] memory;

    always @(posedge clk) begin
        if (write_enable) begin
            memory <= data_in;   // Write data to memory on rising edge of clock
        end
        if (read_enable) begin
            data_out <= memory;  // Read data from memory
        end
    end
endmodule