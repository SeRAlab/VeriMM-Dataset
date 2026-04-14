module ram_256x8 (
    input clk,
    input read_enable,
    input write_enable,
    input [7:0] write_data,
    input [7:0] addr,
    output [7:0] read_data );reg [7:0] memory [255:0];
reg [7:0] read_reg;

always @(posedge clk) begin
    if (write_enable)
        memory[addr] <= write_data;
    if (read_enable)
        read_reg <= memory[addr];
end

assign read_data = read_reg;

endmodule