module edge_detector(CLK, RST, IN_SIG, PULSE);
input CLK, RST, IN_SIG;
output PULSE;
reg PULSE;
reg prev_in_sig;

always @(posedge CLK or posedge RST) begin
    if (RST)
        prev_in_sig <= 0;
    else
        prev_in_sig <= IN_SIG;
end

always @(posedge CLK or posedge RST) begin
    if (RST)
        PULSE <= 0;
    else
        PULSE <= IN_SIG & ~prev_in_sig;
end

endmodule