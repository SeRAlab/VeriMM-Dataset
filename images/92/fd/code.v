module top_module(CLK, D, R, S, Q);input CLK, D, R, S;
output Q;
reg Q;

always @(posedge CLK) begin
    if (R) begin
        Q <= 1'b0;
    end else if (S) begin
        Q <= 1'b1;
    end else begin
        Q <= D;
    end
end

endmodule