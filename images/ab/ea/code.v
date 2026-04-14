module top_module (
    input clk,
    input rst,
    input dir,
    output reg [3:0] q
);
    always @(posedge clk) begin
        if (rst)
            q <= 4'b0000;
        else if (dir)
            q <= q + 1;
        else
            q <= q - 1;
    end
endmodule