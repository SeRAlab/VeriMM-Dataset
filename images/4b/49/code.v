module top_module(
    input clock,
    input [15:0] data,
    input [8:0] rdaddress,
    input [8:0] wraddress,
    input wren,
    output reg [15:0] q
);reg [15:0] ram [511:0]; // 512 x 16-bit RAM

    always @(posedge clock) begin
        if (wren) begin
            ram[wraddress] <= data; // Write data to RAM
        end
    end

    always @(posedge clock) begin
        q <= ram[rdaddress]; // Read data from RAM
    end

endmodule