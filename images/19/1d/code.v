module dram_cell(
    input wire [3:0] data_in,
    output reg [3:0] data_out,
    input wire we,
    input wire re,
    input wire rf,
    input wire clk
);
    reg [3:0] memory;

    always @(posedge clk) begin
        if (we) begin
            memory <= data_in; // Write operation
        end
        if (re) begin
            data_out <= memory; // Read operation
        end
        if (rf) begin
            data_out <= memory; // Refresh operation, retain data
        end
    end
endmodule