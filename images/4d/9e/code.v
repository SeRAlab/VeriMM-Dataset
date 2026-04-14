module top_module(
    input clk,
    input rd_en,
    input wr_en,
    input [9:0] addr,
    input [7:0] data,
    output reg [7:0] q
);// Declare the memory array
    reg [7:0] ram [0:1023];

    always @(posedge clk) begin
        // Read operation
        if (rd_en) begin
            q <= ram[addr]; // Read from RAM
        end
        // Write operation
        if (wr_en) begin
            ram[addr] <= data; // Write to RAM
        end
    end
endmodule