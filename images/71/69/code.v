module top_module(
    input CLK,
    input EN,
    input TE,
    output reg ENCLK
);always @(posedge CLK or negedge EN) begin
    if (EN == 1'b0) begin
        ENCLK <= 1'b0;
    end else if (TE == 1'b1) begin
        ENCLK <= 1'b1;
    end else begin
        ENCLK <= CLK;
    end
end

endmodule