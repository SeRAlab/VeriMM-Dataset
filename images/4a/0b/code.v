module top_module(
    clk,
    rst,
    write_enable,
    write_address,
    write_data,
    read_address_1,
    read_address_2,
    read_data_1,
    read_data_2
);input clk;
input rst;
input write_enable;
input [3:0] write_address;
input [15:0] write_data;
input [3:0] read_address_1;
input [3:0] read_address_2;
output [15:0] read_data_1;
output [15:0] read_data_2;

reg [15:0] registers [0:15];

integer i; // Declare an integer for looping.

always @(posedge clk) begin
    if (rst) begin
        for (i = 0; i < 16; i = i + 1) begin
            registers[i] <= 16'b0; // Reset each register to 0
        end
    end else if (write_enable) begin
        registers[write_address] <= write_data;
    end
end

assign read_data_1 = registers[read_address_1];
assign read_data_2 = registers[read_address_2];

endmodule