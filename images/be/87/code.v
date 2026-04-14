module counter5bit_inc3 (
    input clk,
    input rst,
    input en,
    output [4:0] q
);

    reg [4:0] q_reg;

    always @(posedge clk or posedge rst) begin
        if (rst)
            q_reg <= 5'b0;
        else if (en)
            q_reg <= q_reg + 3;
    end

    assign q = q_reg;

endmodule