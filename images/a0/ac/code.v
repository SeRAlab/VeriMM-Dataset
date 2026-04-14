module counter8bit_up_sync (
    input clk,
    input rst,
    input en,
    output [7:0] q
);

    reg [7:0] q_reg;

    always @(posedge clk) begin
        if (rst)
            q_reg <= 8'b00000000;
        else if (en)
            q_reg <= q_reg + 1;
    end

    assign q = q_reg;

endmodule