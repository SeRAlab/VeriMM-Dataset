module top_module(
    input [31:0] from_mem_data, 
    input [31:0] from_alu_data, 
    input [4:0] regfile_addr_in, 
    input regwrite_in, 
    input memtoreg, 
    output regwrite_out, 
    output [31:0] regfile_data, 
    output [4:0] regfile_addr_out
);wire [31:0] mux_data;
    wire [4:0] mux_addr;

    // Define a 2-to-1 multiplexer for 32-bit data
    assign mux_data = (memtoreg) ? from_mem_data : from_alu_data;

    // Define a 2-to-1 multiplexer for 5-bit addresses
    assign mux_addr = (memtoreg) ? 5'b11111 : regfile_addr_in; // Assuming a default output when memtoreg is 1

    assign regwrite_out = regwrite_in;
    assign regfile_data = mux_data;
    assign regfile_addr_out = mux_addr;
endmodule