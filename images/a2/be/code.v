module register_8bit(
    input [7:0] d,
    input clk, rst, en,
    output reg [7:0] q);

    always @(posedge clk) begin
        if (rst)
            q <= 8'b0;
        else if (en)
            q <= d;
    end
endmodule