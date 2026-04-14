module johnson_counter(
    input clk,
    input reset,
    output reg [11:0] q);always @(posedge clk or posedge reset) begin
    if (reset)
        q <= 12'b000000000001;
    else
        q <= {q[10:0], ~q[11]};
end
endmodule