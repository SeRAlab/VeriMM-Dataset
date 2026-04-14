module counter16bit_down (
    input clk,
    input rst,
    input en,
    output [15:0] q
);

    reg [15:0] q_reg;

    always @(posedge clk or posedge rst) begin
        if (rst)
            q_reg <= 16'b1111111111111111;
        else if (en)
            q_reg <= q_reg - 1;
    end

    assign q = q_reg;

endmodule