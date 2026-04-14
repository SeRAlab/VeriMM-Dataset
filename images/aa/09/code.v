module top_module(CLK, D, SET, RESET, Q, Q_bar);input CLK, D, SET, RESET;
output Q, Q_bar;
reg Q, Q_bar;

always @(posedge CLK) begin
    if (SET) begin
        Q <= 1;
        Q_bar <= 0;
    end else if (RESET) begin
        Q <= 0;
        Q_bar <= 1;
    end else begin
        Q <= D;
        Q_bar <= ~D;
    end
end

endmodule