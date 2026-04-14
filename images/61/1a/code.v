module top_module (
    input clk,
    input rst,
    input ld,
    input [15:0] d,
    output reg [15:0] q
);
    always @(posedge clk) begin
        if (rst)
            q <= 16'b0000000000000000;
        else if (ld)
            q <= d;
        else
            q <= {q[14:0], 1'b0};
    end
endmodule