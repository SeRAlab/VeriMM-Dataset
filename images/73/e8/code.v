module top_module(
    input clock,
    input [7:0] data,
    input [10:0] rdaddress,
    input [11:0] wraddress,
    input wren,
    input rden_b,
    output reg [31:0] q
);reg [31:0] ram [0:4095]; // Declare a RAM array (adjust size as necessary)
    wire [31:0] sub_wire0;
    wire [7:0] sub_wire1;

    // Write data to RAM
    always @(posedge clock) begin
        if (wren) begin
            ram[wraddress[10:0]] <= {24'b0, data}; // Store only lower 8 bits, rest as zero
        end
    end

    // Read data from RAM
    always @(posedge clock) begin
        if (rden_b) begin
            q <= ram[rdaddress]; // Fetch data from RAM
        end
    end

endmodule