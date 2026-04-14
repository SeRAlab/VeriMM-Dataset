module top_module(
    input clk,
    input reg_write,
    input [3:0] write_reg_addr,
    input [31:0] write_data,
    input [3:0] read_reg_addr,
    output reg [31:0] read_data
);reg [31:0] registers [15:0];

always @(posedge clk) begin
    if (reg_write) begin
        registers[write_reg_addr] <= write_data;
    end
    read_data <= registers[read_reg_addr];
end

endmodule