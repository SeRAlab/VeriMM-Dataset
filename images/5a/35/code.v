module counter6bit_down (
    input clk,
    input rst,
    input en,
    input load,
    input [5:0] load_val,
    output [5:0] q
);

    reg [5:0] q_reg;

    always @(posedge clk or posedge rst) begin
        if (rst)
            q_reg <= 6'b111111;
        else if (load)
            q_reg <= load_val;
        else if (en)
            q_reg <= q_reg - 1;
    end

    assign q = q_reg;

endmodule