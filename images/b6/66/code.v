module counter12bit_even (
    input clk,
    input rst,
    output [11:0] q
);

    reg [11:0] q_reg;

    always @(posedge clk or posedge rst) begin
        if (rst)
            q_reg <= 12'b000000000000;
        else
            q_reg <= q_reg + 2;
    end

    assign q = q_reg;

endmodule