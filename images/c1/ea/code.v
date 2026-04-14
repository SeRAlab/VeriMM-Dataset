module clkdlybuf4s (
    input CLK, RST,
    output reg CLK_OUT
);

    parameter DELAY_CYCLES = 4;
    reg [DELAY_CYCLES-1:0] delay_reg;
    integer i;

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            CLK_OUT <= 0;
            delay_reg <= 0;
        end else begin
            delay_reg[0] <= CLK;
            for (i = 1; i < DELAY_CYCLES; i = i+1) begin
                delay_reg[i] <= delay_reg[i-1];
            end
            CLK_OUT <= delay_reg[DELAY_CYCLES-1];
        end
    end

endmodule