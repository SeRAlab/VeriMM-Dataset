module counter8bit_bidirectional (
    input clk,
    input rst,
    input en,
    input load,
    input up_down,
    input [7:0] load_val,
    output [7:0] q
);

    reg [7:0] q_reg;

    always @(posedge clk or posedge rst) begin
        if (rst)
            q_reg <= 8'b0;
        else if (load)
            q_reg <= load_val;
        else if (en) begin
            if (up_down)
                q_reg <= q_reg + 1;
            else
                q_reg <= q_reg - 1;
        end
    end

    assign q = q_reg;

endmodule