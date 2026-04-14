module counter5bit_updown (
    input clk,
    input rst,
    input en,
    input dir,
    output [4:0] q
);

    reg [4:0] q_reg;

    always @(posedge clk or posedge rst) begin
        if (rst)
            q_reg <= 5'b00000;
        else if (en) begin
            if (dir)
                q_reg <= q_reg + 1;
            else
                q_reg <= q_reg - 1;
        end
    end

    assign q = q_reg;

endmodule