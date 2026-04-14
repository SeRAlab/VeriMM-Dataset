module top_module(
    input clk,
    input [3:0] IN,
    input PL,
    input SL,
    input SR,
    output reg [3:0] q
);always @(posedge clk) begin
        if (PL) begin
            q <= IN;
        end else if (SL) begin
            q <= {q[2:0], q[3]};
        end else if (SR) begin
            q <= {q[0], q[3:1]};
        end
    end

endmodule