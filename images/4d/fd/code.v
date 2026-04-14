module counter13bit_async_load (
    input clk,
    input load,
    input en,
    input [12:0] d,
    output [12:0] q
);

    reg [12:0] q_reg;

    always @(posedge clk or posedge load) begin
        if (load)
            q_reg <= d;
        else if (en)
            q_reg <= q_reg + 1;
    end

    assign q = q_reg;

endmodule