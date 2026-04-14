module counter12bit_up_sync_clr (
    input clk,
    input clr,
    input en,
    output [11:0] q
);

    reg [11:0] q_reg;

    always @(posedge clk) begin
        if (clr)
            q_reg <= 12'b0;
        else if (en)
            q_reg <= q_reg + 1;
    end

    assign q = q_reg;

endmodule