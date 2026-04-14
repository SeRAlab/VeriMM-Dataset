module top_module(
    input clock,
    input [31:0] data,
    input [4:0] rdaddress,
    input [4:0] wraddress,
    input wren,
    output reg [31:0] q
);reg [31:0] ram [31:0]; // Declare a simple register file of size 32

    always @(posedge clock) begin
        if (wren) begin
            ram[wraddress] <= data; // Write data to the specified address
        end
    end

    always @(posedge clock) begin
        q <= ram[rdaddress]; // Read data from the specified address
    end

endmodule