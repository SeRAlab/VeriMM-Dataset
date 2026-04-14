module top_module(CLK, J, K, D, S, Q, Q_bar);input CLK, J, K, D, S;
output Q, Q_bar;

reg Q, Q_bar;

always @(posedge CLK) begin
    if (S) begin
        Q <= 1'b1;
        Q_bar <= 1'b0;
    end else if (J && K) begin
        Q <= ~Q;
        Q_bar <= Q;
    end else if (J) begin
        Q <= 1'b1;
        Q_bar <= 1'b0;
    end else if (K) begin
        Q <= 1'b0;
        Q_bar <= 1'b1;
    end else begin
        Q <= D;
        Q_bar <= ~D;
    end
end

endmodule