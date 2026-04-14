module top_module(CK, D, SN, RST, Q, QN);input CK, D, SN, RST;
output Q, QN;
reg Q;

always @(posedge CK) begin
    if (SN && !RST) begin // set
        Q <= 1;
    end else if (RST && !SN) begin // reset
        Q <= 0;
    end else if (SN && RST) begin // priority to reset
        Q <= 0;
    end else begin // normal operation
        Q <= D;
    end
end

assign QN = ~Q;

endmodule