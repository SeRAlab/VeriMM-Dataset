module register_8bit(
    input clk,
    input clr_n,
    input en,
    input [7:0] d,
    output reg [7:0] q
);

    always @(posedge clk or negedge clr_n) begin
        if (!clr_n)
            q <= 8'b00000000;
        else if (en)
            q <= d;
    end

endmodule