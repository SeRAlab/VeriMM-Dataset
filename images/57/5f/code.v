module top_module(
    reset,
    clk,
    address0,
    ce0,
    q0);parameter DataWidth = 32'd8;
parameter AddressRange = 32'd256;
parameter AddressWidth = 32'd8;
input reset;
input clk;
input[AddressWidth - 1:0] address0;
input ce0;
output[DataWidth - 1:0] q0;

reg[DataWidth - 1:0] rom[AddressRange - 1:0];

integer i;

always @ (posedge clk) begin
    if (reset) begin
        for (i = 0; i < AddressRange; i = i + 1) begin
            rom[i] <= i % 256;
        end
    end
end

assign q0 = ce0 ? rom[address0] : 0;

endmodule