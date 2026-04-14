module top_module(
    aclr,
    clock,
    q
);input aclr;
    input clock;
    output reg [7:0] q;

    always @(posedge clock, negedge aclr) begin
        if (~aclr) begin
            q <= 8'b0;
        end else if (q == 8'hff) begin
            q <= 8'b0;
        end else begin
            q <= q + 1;
        end
    end

endmodule