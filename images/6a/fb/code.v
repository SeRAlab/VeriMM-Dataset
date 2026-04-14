module dual_port_ram #(
    parameter DATAWIDTH = 8,
    parameter DEPTH = 256
) (
    input wire clk,
    input wire we,
    input wire [$clog2(DEPTH)-1:0] addr_wr,
    input wire [DATAWIDTH-1:0] data_wr,
    input wire [$clog2(DEPTH)-1:0] addr_rd,
    output reg [DATAWIDTH-1:0] data_rd
);

reg [DATAWIDTH-1:0] mem [0:DEPTH-1];

always @(posedge clk) begin
    if (we) begin
        mem[addr_wr] <= data_wr;
    end
    data_rd <= mem[addr_rd];
end

endmodule