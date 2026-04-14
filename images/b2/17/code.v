module top_module(
    input CLK, EN, TE,
    output reg ENCLK
);always @(posedge CLK) begin
    if (EN) begin
        if (TE) begin
            ENCLK <= CLK;
        end else begin
            ENCLK <= 1'b1;
        end
    end else begin
        ENCLK <= 1'b0;
    end
end

endmodule