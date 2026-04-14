module top_module(CLK, D, SET, CLR, EN, Q, Qbar);input CLK;
input D;
input SET;
input CLR;
input EN;
output Q;
output Qbar;

reg Q;
reg Qbar;

always @(posedge CLK) begin
    if (EN) begin
        if (SET) begin
            Q <= 1;
            Qbar <= 0;
        end else if (CLR) begin
            Q <= 0;
            Qbar <= 1;
        end else begin
            Q <= D;
            Qbar <= ~D;
        end
    end
end

endmodule