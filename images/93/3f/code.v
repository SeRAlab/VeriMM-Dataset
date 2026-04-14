module counter3bit (
    input clk,
    input rst,
    output [2:0] q
);

    reg [2:0] q_reg;

    always @(posedge clk or posedge rst) begin
        if (rst)
            q_reg <= 3'b000;
        else
            q_reg <= q_reg + 1;
    end

    assign q = q_reg;

endmodule