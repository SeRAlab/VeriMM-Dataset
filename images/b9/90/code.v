module top_module(
    input clock,
    input [31:0] data,
    input [4:0] rdaddress,
    input [4:0] wraddress,
    input wren,
    output reg [31:0] q
);// Declare a memory array for the register bank
    reg [31:0] ram [0:31]; // 32 registers, each 32 bits wide

    always @(posedge clock) begin
        if (wren) begin
            ram[wraddress] <= data; // Write data to the specified register
        end
    end

    always @(posedge clock) begin
        q <= ram[rdaddress]; // Read data from the specified register
    end

endmodule