module top_module(
    input CLK,
    input EN,
    input TE,
    output reg ENCLK
);reg D;

always @(posedge CLK) begin
    if (EN) begin
        D <= CLK;
    end
end

always @(posedge CLK) begin
    if (TE) begin
        ENCLK <= D;
    end
end

endmodule