module d_ff_async (
    input clk,
    input rst,
    input d,
    output q
);

    reg q_reg;

    always @(posedge clk or posedge rst) begin
        if (rst)
            q_reg <= 1'b0;
        else
            q_reg <= d;
    end

    assign q = q_reg;

endmodule