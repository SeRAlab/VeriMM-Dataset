module lfsr(
    input clk,
    input reset,
    input enable,
    output reg [8:0] q);

always @(posedge reset, posedge clk) begin
    if (reset)
        q <= 9'b111111111;
    else if (enable)
        q <= {q[0] ^ q[3], q[8:1]};
end
endmodule