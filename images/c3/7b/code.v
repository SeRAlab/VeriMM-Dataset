module clock_gate (CLK, EN, TE, ENCLK);

input CLK, EN, TE;
output ENCLK;

reg ENCLK;

always @ (posedge CLK) begin
    if (EN) begin
        ENCLK <= CLK;
    end else begin
        ENCLK <= 1'b0;
    end
end

assign ENCLK = (TE) ? CLK : ENCLK;

endmodule