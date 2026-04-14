module d_ff (CLK, RST, EN, D, Q);
input CLK, RST, EN, D;
output reg Q;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Q <= 1'b0;
    end else if (EN) begin
        Q <= D;
    end
end

endmodule