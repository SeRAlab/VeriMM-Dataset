module counter4bit_down (
    input clk,
    input rst,
    input en,
    output [3:0] q
);

    reg [3:0] q_reg;

    always @(posedge clk or posedge rst) begin
        if (rst)
            q_reg <= 4'b1111;
        else if (en)
            q_reg <= q_reg - 1;
    end

    assign q = q_reg;

endmodule