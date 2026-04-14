module dram_4bit (
    input wire clk,
    input wire we,
    input wire rd,
    input wire [3:0] data_in,
    output reg [3:0] data_out
);
    reg [3:0] memory;

    always @(posedge clk) begin
        if (we) begin
            memory <= data_in; // Write data to memory
        end
    end

    always @(posedge clk) begin
        if (rd) begin
            data_out <= memory; // Read data from memory
        end
    end
endmodule