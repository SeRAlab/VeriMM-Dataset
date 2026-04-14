module reg_file_32x32 (
    input clk,
    input write_enable,
    input [4:0] read_addr1,
    input [4:0] read_addr2,
    input [4:0] write_addr,
    input [31:0] write_data,
    output [31:0] read_data1,
    output [31:0] read_data2 );

reg [31:0] memory [31:0];
reg [31:0] read_reg1, read_reg2;

always @(posedge clk) begin
    if (write_enable)
        memory[write_addr] <= write_data;
    read_reg1 <= memory[read_addr1];
    read_reg2 <= memory[read_addr2];
end

assign read_data1 = read_reg1;
assign read_data2 = read_reg2;

endmodule