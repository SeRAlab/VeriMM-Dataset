module counter11bit_sync_reset (
    input clk,
    input rst,
    input en,
    output [10:0] q
);

    reg [10:0] q_reg;

    always @(posedge clk) begin
        if (rst)
            q_reg <= 11'b00000000000;
        else if (en)
            q_reg <= q_reg + 1;
    end

    assign q = q_reg;

endmodule