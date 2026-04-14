module counter10bit_up_down (
    input clk,
    input rst,
    input en,
    input up_down,
    output [9:0] q
);

    reg [9:0] q_reg;

    always @(posedge clk or posedge rst) begin
        if (rst)
            q_reg <= 10'b0;
        else if (en) begin
            if (up_down)
                q_reg <= q_reg + 1;
            else
                q_reg <= q_reg - 1;
        end
    end

    assign q = q_reg;

endmodule