module top_module(CLK, EN, TE, RESET, OUT);input CLK, EN, TE, RESET;
output OUT;

reg OUT;

always @(posedge CLK) begin
    if (RESET) begin
        OUT <= 0;
    end else if (EN) begin
        OUT <= 1;
    end
end

endmodule