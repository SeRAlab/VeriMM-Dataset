module register_16bit(
    input [15:0] d,
    input clk, rst, en,
    output reg [15:0] q);

    always @(posedge clk) begin
        if (rst)
            q <= 16'b0;
        else if (en)
            q <= d;
    end
endmodule