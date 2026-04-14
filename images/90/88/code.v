module top_module(CLK, EN, TE, reset, ENCLK);input CLK, EN, TE, reset;
    output ENCLK;

    reg ENCLK_reg;

    always @(posedge CLK, posedge reset) begin
        if (reset) begin
            ENCLK_reg <= 1'b0;
        end else if (EN) begin
            ENCLK_reg <= CLK;
        end
    end

    assign ENCLK = TE ? ENCLK_reg : 1'b0;
endmodule