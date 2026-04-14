module counter9bit_par_load (
    input clk,
    input rst,
    input en,
    input load,
    input [8:0] d,
    output [8:0] q
);

    reg [8:0] q_reg;

    always @(posedge clk or posedge rst) begin
        if (rst)
            q_reg <= 9'b000000000;
        else if (load)
            q_reg <= d;
        else if (en)
            q_reg <= q_reg + 1;
    end

    assign q = q_reg;

endmodule