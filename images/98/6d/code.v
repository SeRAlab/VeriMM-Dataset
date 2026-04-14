module circular_shift_register(
    input clk,
    input reset,
    input shift,
    output reg [4:0] q);

always @(posedge clk) begin
    if (reset)
        q <= 5'b00000;
    else if (shift)
        q <= {q[0], q[4:1]};
end
endmodule