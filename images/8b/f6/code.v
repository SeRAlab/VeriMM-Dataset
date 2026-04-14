module sram_32x32 (
    input clk,
    input write_enable,
    input [3:0] byte_enable,
    input [4:0] addr,
    input [31:0] write_data,
    output [31:0] read_data );

reg [31:0] memory [31:0];
reg [31:0] read_reg;

always @(posedge clk) begin
    if (write_enable) begin
        if (byte_enable[0]) memory[addr][7:0] <= write_data[7:0];
        if (byte_enable[1]) memory[addr][15:8] <= write_data[15:8];
        if (byte_enable[2]) memory[addr][23:16] <= write_data[23:16];
        if (byte_enable[3]) memory[addr][31:24] <= write_data[31:24];
    end
    read_reg <= memory[addr];
end

assign read_data = read_reg;

endmodule