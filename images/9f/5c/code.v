module top_module(
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input clk,
    input load,
    input rst,
    output reg [3:0] q
);always @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= 4'b0000;
        end else if (load) begin
            q <= {d, c, b, a};
        end else begin
            q <= {q[2:0], a};
        end
    end

endmodule