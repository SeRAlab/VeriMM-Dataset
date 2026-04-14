module DRAMCell(
    input clk,
    input we,             // write enable
    input [15:0] data_in, // data input
    output reg [15:0] data_out // data output
);
    reg [15:0] memory; // internal storage

    always @(posedge clk) begin
        if (we) begin
            memory <= data_in; // write data to memory
        end
        data_out <= memory; // output the stored data
    end
endmodule