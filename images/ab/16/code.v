module shift_register(
    input clk,
    input reset,
    input shift,
    input in,
    output reg [7:0] q);

always @(posedge reset, posedge clk) begin
    if (reset)
        q <= 8'b00000000;
    else if (shift)
        q <= {q[6:0], in};
end
endmodule