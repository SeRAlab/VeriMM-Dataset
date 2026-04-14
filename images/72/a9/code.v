module top_module(input clk, input d, output reg [2:0] q);always @(posedge clk)
    q <= {q[1:0], d};

endmodule