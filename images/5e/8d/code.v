module shift_register (
    input clk,
    input sin,
    output [3:0] q
);

    reg [3:0] q_reg;

    always @(posedge clk) begin
        q_reg <= {q_reg[2:0], sin};
    end

    assign q = q_reg;

endmodule