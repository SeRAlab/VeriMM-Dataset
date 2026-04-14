module t_ff (CLK, RST, T, Q);
input CLK, RST, T;
output reg Q;

always @(posedge CLK) begin
    if (RST) begin
        Q <= 1'b0;
    end else if (T) begin
        Q <= ~Q;
    end
end

endmodule