module top_module(CLK, D, SET, RESET, Q, QN);input CLK, D, SET, RESET;
output Q, QN;
reg Q, QN;

always @(posedge CLK or posedge SET or posedge RESET) begin
    if (SET) begin
        Q <= 1'b1;
        QN <= 1'b0;
    end else if (RESET) begin
        Q <= 1'b0;
        QN <= 1'b1;
    end else begin
        Q <= D;
        QN <= ~D;
    end
end

endmodule