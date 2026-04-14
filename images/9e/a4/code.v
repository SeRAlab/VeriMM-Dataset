module counter16bit_up (
    input clk,
    input rst,
    input en,
    input load,
    input [15:0] load_val,
    output [15:0] q
);

    reg [15:0] q_reg;

    always @(posedge clk or posedge rst) begin
        if (rst)
            q_reg <= 16'b0;
        else if (load)
            q_reg <= load_val;
        else if (en)
            q_reg <= q_reg + 1;
    end

    assign q = q_reg;

endmodule