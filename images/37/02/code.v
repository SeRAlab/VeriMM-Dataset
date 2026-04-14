module dram_cell (
    input wire write_enable,
    input wire [15:0] data_in,
    input wire clk,
    output reg [15:0] data_out
);
    reg [15:0] memory; // Internal memory storage

    always @(posedge clk) begin
        if (write_enable) begin
            memory <= data_in; // Write data to memory
        end
        data_out <= memory; // Output current memory content
    end
endmodule