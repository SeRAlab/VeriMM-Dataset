module ring_counter (
    input clk,
    input reset,
    input en,
    output reg [7:0] q);always @(posedge clk) begin
    if (reset)
        q <= 8'b00000001;
    else if (en)
        q <= {q[6:0], q[7]};
end
endmodule