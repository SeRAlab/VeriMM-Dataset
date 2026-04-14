module register_with_enable (
    input [7:0] d,
    input clk,
    input en,
    output [7:0] q
);

    reg [7:0] q_reg;

    always @(posedge clk) begin
        if (en) begin
            q_reg <= d;
        end
    end

    assign q = q_reg;

endmodule