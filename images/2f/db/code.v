module dram_cell (
    input clk,
    input we, // Write enable
    input [7:0] data_in, // 8-bit input data
    output reg [7:0] data_out // 8-bit output data
);
    reg [7:0] memory; // 8-bit storage

    always @(posedge clk) begin
        if (we) begin
            memory <= data_in; // Write operation
        end
        data_out <= memory; // Read operation
    end
endmodule