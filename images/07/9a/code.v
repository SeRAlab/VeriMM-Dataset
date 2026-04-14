module dram_cell (
    input wire [3:0] data_in,
    input wire word_line,
    input wire write_enable,
    output reg [3:0] data_out
);
    reg [3:0] memory;

    always @(posedge word_line) begin
        if (write_enable) begin
            memory <= data_in; // Write data to memory
        end
    end

    always @(negedge word_line) begin
        data_out <= memory; // Read data from memory when word line is inactive
    end
endmodule