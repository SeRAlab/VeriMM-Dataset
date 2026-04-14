module clock_gate(
    input CLK,
    input EN,
    input TE,
    output reg ENCLK
);

reg gated_clk;

always @ (posedge CLK) begin
    if (EN & !TE) begin
        gated_clk <= 1'b1;
    end else begin
        gated_clk <= 1'b0;
    end
end

always @ (*) begin
    if (TE) begin
        ENCLK = CLK;
    end else begin
        ENCLK = gated_clk ? CLK : ENCLK;
    end
end

endmodule