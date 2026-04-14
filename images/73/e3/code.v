module d_flip_flop (CLK, D, RST, EN, Q);
input CLK, D, RST, EN;
output reg Q;

always @(posedge CLK) begin
    if (RST) begin
        Q <= 1'b0;
    end
    else if (EN) begin
        Q <= D;
    end
end

endmodule