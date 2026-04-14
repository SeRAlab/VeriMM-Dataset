module register_32bit(
    input [31:0] d,
    input clk, rst, en,
    output reg [31:0] q);

    always @(posedge clk) begin
        if (rst)
            q <= 32'b0;
        else if (en)
            q <= d;
    end
endmodule