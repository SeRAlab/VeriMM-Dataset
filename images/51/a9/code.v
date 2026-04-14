module top_module(clk, we, addr, data_in, data_out);parameter RAM_SIZE = 256;
parameter WORD_SIZE = 32;

input clk;
input we;
input [7:0] addr;
input [WORD_SIZE-1:0] data_in;
output reg [WORD_SIZE-1:0] data_out; // Change the output to reg type

reg [WORD_SIZE-1:0] ram [0:RAM_SIZE-1];

always @(posedge clk) begin
    if (we) begin
        ram[addr] <= data_in;
    end
    data_out <= ram[addr]; // data_out can now be assigned
end

endmodule