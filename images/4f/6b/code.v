module reg_file(
    input clk,
    input write_enable,
    input [1:0] write_address,
    input [1:0] read_address,
    input [31:0] write_data,
    output reg [31:0] read_data);reg [31:0] registers [3:0];

always @(posedge clk) begin
    if (write_enable)
        registers[write_address] <= write_data;
end

always @(*) begin
    read_data = registers[read_address];
end
endmodule