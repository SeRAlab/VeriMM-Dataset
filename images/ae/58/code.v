module dual_port_ram #(
    parameter DATAWIDTH = 8,
    parameter ADDRWIDTH = 8
) (
    input wire clk,
    input wire we,
    input wire [ADDRWIDTH-1:0] write_addr,
    input wire [ADDRWIDTH-1:0] read_addr,
    input wire [DATAWIDTH-1:0] din,
    output reg [DATAWIDTH-1:0] dout
);
    reg [DATAWIDTH-1:0] ram [2**ADDRWIDTH-1:0];

    always @(posedge clk) begin
        if (we)
            ram[write_addr] <= din;
        dout <= ram[read_addr];
    end
endmodule