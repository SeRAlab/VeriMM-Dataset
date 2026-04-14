module top_module (
    input clk,
    input rst,
    input d,
    output reg [3:0] q
);
    always @(posedge clk) begin
        if (rst)
            q <= 4'b0000;
        else
            q <= {q[2:0], d};
    end
endmodule