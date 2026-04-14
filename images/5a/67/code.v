module loadable_register(
    input clk,
    input clear,
    input load,
    input [7:0] data_in,
    output reg [7:0] q);
always @(posedge clk) begin
    if (clear)
        q <= 8'b00000000;
    else if (load)
        q <= data_in;
end
endmodule