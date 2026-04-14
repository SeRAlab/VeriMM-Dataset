module dual_port_ram_8x16(
    input clk,
    input we,
    input [3:0] w_addr,
    input [7:0] w_data,
    input [3:0] r_addr1,
    input [3:0] r_addr2,
    output reg [7:0] r_data1,
    output reg [7:0] r_data2
);

reg [7:0] ram [15:0];

always @(posedge clk)
    if (we)
        ram[w_addr] <= w_data;

always @(*)
begin
    r_data1 = ram[r_addr1];
    r_data2 = ram[r_addr2];
end

endmodule