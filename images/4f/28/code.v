module lfsr_12bit (
    input clk,
    input reset,
    input en,
    output reg [11:0] q);
always @(posedge clk) begin
    if (reset)
        q <= 12'b000000000001;
    else if (en)
        q <= {q[10:0], q[11] ^ q[3]};
end
endmodule