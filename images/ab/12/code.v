module d_flip_flop (
    input d,
    input clk,
    output q
);

    reg q_reg;

    always @(posedge clk) begin
        q_reg <= d;
    end

    assign q = q_reg;

endmodule