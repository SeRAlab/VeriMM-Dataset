module ring_counter (
    input clk,
    input reset_n,
    input en,
    output reg [8:0] q);

always @(posedge clk) begin
    if (!reset_n)
        q <= 9'b000000001;
    else if (en) begin
        q <= {q[7:0], q[8]};
    end
end

endmodule