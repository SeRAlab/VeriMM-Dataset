module reg_file(
    input clk,
    input we,
    input [4:0] write_addr,
    input [4:0] read_addr1,
    input [4:0] read_addr2,
    input [31:0] write_data,

    output [31:0] read_data1,
    output [31:0] read_data2
);

reg [31:0] registers [31:0];

assign read_data1 = registers[read_addr1];
assign read_data2 = registers[read_addr2];

always @(posedge clk) begin
    if (we) begin
        registers[write_addr] <= write_data;
    end
end

endmodule