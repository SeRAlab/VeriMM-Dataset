module dual_port_ram_32bit_8word (
    input clk,
    input wr_en,
    input [2:0] rd_addr,
    input [2:0] wr_addr,
    input [31:0] data_in,
    output reg [31:0] data_out
);

reg [31:0] mem [0:7];

always @(posedge clk) begin
    if (wr_en) begin
        mem[wr_addr] <= data_in;
    end
    data_out <= mem[rd_addr];
end

endmodule