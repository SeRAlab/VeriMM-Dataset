module top_module(
    GATE,
    SCE,
    CLK,
    GCLK
);input GATE;
    input SCE;
    input CLK;
    output GCLK;

    reg d_ff_out;

    always @(posedge CLK, negedge SCE) begin
        if (!SCE) begin
            d_ff_out <= 1'b0;
        end else begin
            d_ff_out <= GATE;
        end
    end

    assign GCLK = GATE & d_ff_out;

endmodule