module shift_register (
    input clk,
    input reset,
    input en,
    input shift,
    output reg [3:0] q);
always @(posedge clk) begin
    if (reset)
        q <= 4'b0000;
    else if (en) begin
        if (shift)
            q <= {q[2:0], 1'b0};
    end
end
endmodule