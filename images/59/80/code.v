module counter20bit_inc4 (
    input clk,
    input rst,
    input en,
    output [19:0] q
);

    reg [19:0] q_reg;

    always @(posedge clk or posedge rst) begin
        if (rst)
            q_reg <= 20'b0;
        else if (en)
            q_reg <= q_reg + 4;
    end

    assign q = q_reg;

endmodule