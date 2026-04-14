module top_module(
    input clk,
    input write_enable,
    input [1:0] write_address,
    input [15:0] write_data,
    input [1:0] read_address_1,
    input [1:0] read_address_2,
    output reg [15:0] read_data_1,
    output reg [15:0] read_data_2
);reg [15:0] registers [3:0];

always @(posedge clk) begin
    if (write_enable) begin
        registers[write_address] <= write_data;
    end
    read_data_1 <= registers[read_address_1];
    read_data_2 <= registers[read_address_2];
end

endmodule