module top_module(
    input [10:0] address,
    input clock,
    input [15:0] data,
    input wren,
    output reg [15:0] q
);reg [15:0] ram [0:2047]; // 2^11 = 2048 locations, each 16 bits wide

    always @(posedge clock) begin
        if (wren) begin
            ram[address] <= data; // Write data to the memory
        end
        q <= ram[address]; // Read data from the memory
    end

endmodule