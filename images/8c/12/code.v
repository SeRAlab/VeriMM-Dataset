module reg_file_16x128 (
    input clk,
    input write_enable,
    input [3:0] read_addr,
    input [3:0] write_addr,
    input [127:0] write_data,
    output [127:0] read_data );

reg [127:0] memory [15:0];
reg [127:0] read_reg;

always @(posedge clk) begin
    if (write_enable)
        memory[write_addr] <= write_data;
    read_reg <= memory[read_addr];
end

assign read_data = read_reg;

endmodule