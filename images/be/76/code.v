module counter4bit_sync (
    input clk,
    input rst,
    output [3:0] q
);

    reg [3:0] q_reg;

    always @(posedge clk) begin
        if (rst)
            q_reg <= 4'b0000;
        else
            q_reg <= q_reg + 1;
    end

    assign q = q_reg;

endmodule