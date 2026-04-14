module reg_file_8x64 (
    input clk,
    input write_enable,
    input [2:0] write_addr,
    input [2:0] read_addr,
    input [63:0] write_data,
    output [63:0] read_data );

reg [63:0] memory [7:0];

always @(posedge clk) begin
    if (write_enable)
        memory[write_addr] <= write_data;
end

assign read_data = memory[read_addr];

endmodule