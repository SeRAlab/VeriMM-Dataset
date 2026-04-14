module ring_counter_neg (
    input clk,
    input reset_n,
    input en,
    output reg [6:0] q);

always @(negedge clk or negedge reset_n) begin
    if (!reset_n)
        q <= 7'b0000001;
    else if (en) begin
        q <= {q[5:0], q[6]};
    end
end

endmodule