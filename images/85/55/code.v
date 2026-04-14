module register_file (
    input clk,
    input we,
    input [1:0] addr,
    input [7:0] din,
    output reg [7:0] dout
);
    reg [7:0] registers [3:0];

    always @(posedge clk) begin
        if (we)
            registers[addr] <= din;
        dout <= registers[addr];
    end
endmodule