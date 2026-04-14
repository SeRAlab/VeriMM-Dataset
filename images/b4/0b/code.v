module regfile_32bit_16(
    input clk,           // Clock signal.
    input rst,           // Reset signal.
    input we,            // Write enable signal.
    input [3:0] waddr,   // 4-bit write address.
    input [3:0] raddr1,  // 4-bit read address for the first read port.
    input [3:0] raddr2,  // 4-bit read address for the second read port.
    input [31:0] wdata,  // 32-bit write data.

    output [31:0] rdata1, // 32-bit data from the first read port.
    output [31:0] rdata2  // 32-bit data from the second read port.
);

reg [31:0] regfile [15:0]; // 16 registers of 32-bit each.
integer i;

//------------------------------------------------
// Write operation
always @(posedge clk) begin
    if (rst) begin
        for (i = 0; i < 16; i = i + 1) begin
            regfile[i] <= 32'b0; // Reset all registers to 0
        end
    end
    else if (we) begin
        regfile[waddr] <= wdata; // Write data to the register
    end
end

//------------------------------------------------
// Read operation
assign rdata1 = regfile[raddr1]; // Read data from the first read port
assign rdata2 = regfile[raddr2]; // Read data from the second read port

endmodule