module johnson_counter_8bit(
    input clk,
    input reset,
    output reg [7:0] q
);

always @(posedge clk) begin
    if (reset)
        q <= 8'b00000001;
    else
        q <= {q[6:0], ~q[7]};
end

endmodule