module d_flip_flop (CLK, RST, D, Q);
input CLK, RST, D;
output reg Q;

always @(posedge CLK) begin
    if (RST) begin
        Q <= 1'b0;
    end else begin
        Q <= D;
    end
end

endmodule