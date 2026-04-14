module register_8bit(
    input [7:0] d,
    input clk,
    input rst,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (rst)
            q <= 8'b00000000;
        else
            q <= d;
    end

endmodule