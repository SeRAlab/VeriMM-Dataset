module top_module(
    input CLK, EN, TE, RST,
    output reg ENCLK
);reg D;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        D <= 1'b0;
        ENCLK <= 1'b0;
    end else begin
        D <= EN & TE;
        ENCLK <= D;
    end
end

endmodule