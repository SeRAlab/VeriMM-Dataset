module dram_cell (
    input wire [3:0] data_in,
    input wire read_en,
    input wire write_en,
    input wire clk,
    output reg [3:0] data_out
);

    reg [3:0] memory;

    always @(posedge clk) begin
        if (write_en) begin
            memory <= data_in; // Write data to memory
        end
    end

    always @(posedge clk) begin
        if (read_en) begin
            data_out <= memory; // Read data from memory
        end
    end
endmodule