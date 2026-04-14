module top_module(
    input CLK,
    input EN,
    input TE,
    output reg ENCLK
);reg D;
wire G;

assign G = TE & EN;

always @(posedge CLK, posedge EN) begin
    if (EN) begin
        D <= 1'b0;
        ENCLK <= 1'b0;
    end else begin
        D <= G;
        ENCLK <= D;
    end
end

endmodule