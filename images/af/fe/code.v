module johnson_counter3 (
    input clk,
    input reset,
    output reg [2:0] q);always @(posedge clk) begin
    if (reset)
        q <= 3'b0;
    else
        q <= {~q[0], q[2:1]};
end
endmodule