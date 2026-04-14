module top_module(input CLK, EN, TE, output reg ENCLK);always @(*) begin
        if (TE) begin
            ENCLK <= CLK;
        end else if (EN) begin
            ENCLK <= CLK;
        end else begin
            ENCLK <= 1'b0;
        end
    end
endmodule