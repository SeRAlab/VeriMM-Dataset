module clock_gate (
    input CLK,
    input EN,
    input TE,
    output reg ENCLK
);

always @ (posedge CLK) begin
    if (EN && TE) begin
        ENCLK <= 1;
    end else begin
        ENCLK <= 0;
    end
end

endmodule