module top_module(
    address,
    byteena,
    clken,
    clock,
    data,
    wren,
    q
);input [9:0] address;
input [1:0] byteena;
input clken;
input clock;
input [15:0] data;
input wren;
output reg [15:0] q;  // Output should be reg since we're assigning within always block

parameter RAM_DEPTH = 1024;
parameter RAM_WIDTH = 16;

reg [RAM_WIDTH-1:0] ram [0:RAM_DEPTH-1];  // RAM array declaration

always @(posedge clock) begin
    if(clken) begin
        if(wren) begin
            // Write data to RAM with byte enabling
            if(byteena[0]) begin
                ram[address][7:0] <= data[7:0];  // Write lower byte
            end
            if(byteena[1]) begin
                ram[address][15:8] <= data[15:8]; // Write upper byte
            end
        end
        q <= ram[address];  // Read data from RAM
    end
end

endmodule