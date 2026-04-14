module reg16_sync (
    input clk,
    input load,
    input clr,
    input [15:0] d,
    output [15:0] q
);

    reg [15:0] q_reg;

    always @(posedge clk) begin
        if (clr)
            q_reg <= 16'b0;
        else if (load)
            q_reg <= d;
    end

    assign q = q_reg;

endmodule