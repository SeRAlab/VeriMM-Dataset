module counter7bit_load (
    input clk,
    input rst,
    input load,
    input [6:0] d,
    output [6:0] q
);

    reg [6:0] q_reg;

    always @(posedge clk or posedge rst) begin
        if (rst)
            q_reg <= 7'b0000000;
        else if (load)
            q_reg <= d;
        else
            q_reg <= q_reg + 1;
    end

    assign q = q_reg;

endmodule