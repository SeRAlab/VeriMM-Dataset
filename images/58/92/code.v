module shift_register4bit (
    input clk,
    input rst,
    input d,
    output [3:0] q
);

    reg [3:0] q_reg;

    always @(posedge clk or posedge rst) begin
        if (rst)
            q_reg <= 4'b0000;
        else
            q_reg <= {q_reg[2:0], d};
    end

    assign q = q_reg;

endmodule