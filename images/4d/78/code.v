module ring_counter (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk or negedge reset) begin
    if (~reset)
        q <= 4'b0001;
    else
        q <= {q[2:0], q[3]};
end

endmodule