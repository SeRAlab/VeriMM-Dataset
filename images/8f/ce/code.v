module top_module(
    input clk,
    input [15:0] addr,
    input [31:0] data_in,
    input write_en,
    output reg [31:0] data_out
);parameter ABITS = 16;
parameter DBITS = 32;
parameter [65535:0] INIT = 65535'b0;

reg [31:0] upper_data_out;
wire upper_write_en;
wire [31:0] upper_data_in;
wire [15:0] upper_addr;

// Assuming an address space where upper_addr is for higher RAM and addr is for lower RAM
assign upper_addr = addr; // Adjust based on the actual memory mapping
assign upper_data_in = data_out; // Use a proper mechanism to get `upper_data_in` if `data_out` is not correct
assign upper_write_en = write_en & (addr >= 32768);

// Placeholder for the CC_BRAM_40K module
// This should be replaced with the correct implementation or included library/module
reg [DBITS-1:0] memory [0:65535]; // Example memory declaration

// Simulated read and write behavior
always @(posedge clk) begin
    if (upper_write_en) 
        memory[upper_addr] <= upper_data_in; // Write data to upper memory
    upper_data_out <= memory[upper_addr]; // Read data from upper memory
end

always @(posedge clk) begin
    if (write_en) 
        memory[addr] <= data_in; // Write data to lower memory
    data_out <= memory[addr]; // Read data from lower memory
end

endmodule