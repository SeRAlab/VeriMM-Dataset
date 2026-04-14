module top_module(
    input CLK,
    input EN,
    input TE,
    input RESET,
    output reg ENCLK
);reg last_ENCLK;
reg last_TE;

always @(posedge CLK) begin
    if (RESET) begin
        ENCLK <= 1'b0;
    end else if (!EN) begin
        ENCLK <= 1'b0;
    end else if (TE) begin
        ENCLK <= CLK;
    end else begin
        ENCLK <= last_ENCLK;
    end
    last_ENCLK <= ENCLK;
    last_TE <= TE;
end

endmodule