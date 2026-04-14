module top_module(
    input CLK,
    input EN,
    input TE,
    output reg ENCLK
);always @(posedge CLK) begin
    if (EN) begin
        ENCLK <= 1'b1;
    end else if (TE) begin
        ENCLK <= 1'b1;
    end else begin
        ENCLK <= ENCLK;
    end
end

endmodule