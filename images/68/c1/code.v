module johnson_counter (
    input clk,
    input reset,
    input en,
    output reg [9:0] q);
always @(posedge clk) begin
    if (reset)
        q <= 10'b0000000001;
    else if (en)
        q <= {~q[0], q[9:1]};
end
endmodule