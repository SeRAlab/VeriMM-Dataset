module johnson_counter_10bit(
    input clk,
    input reset,
    output reg [9:0] q
);

always @(posedge clk) begin
    if (reset)
        q <= 10'b0000000000;
    else
        q <= {q[8:0], ~q[9]};
end

endmodule