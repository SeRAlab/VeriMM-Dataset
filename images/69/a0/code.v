module fibonacci_lfsr (
    input clk,
    input reset_n,
    input en,
    output reg [9:0] q);

always @(posedge clk) begin
    if (!reset_n)
        q <= 10'b0000000001;
    else if (en) begin
        q <= {q[8:0], q[9] ^ q[6]};
    end
end

endmodule