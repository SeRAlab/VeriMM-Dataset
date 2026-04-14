module top_module(D, CK, H, SM, SI, Q, XQ, SO);input   D;
input   CK;
input   H;
input   SM;
input   SI;
output  Q;
output  XQ;
output  SO;

// intermediate signals
wire w1;
wire w5;
wire w4;
wire w0;
wire IQ;

// AND gate
and g0(IQ, H, SI);

// inverter
not g1(w5, H);

// AND gate
and g2(w4, w5, D);

// OR gate
or g3(w0, IQ, w4);

// Behavioral D Flip-Flop
reg IQ_reg; // Register for the flip-flop output

always @(posedge CK or negedge H) begin
    if (!H) begin
        IQ_reg <= 0; // Asynchronous reset
    end else if (SM) begin
        IQ_reg <= SI; // Scan-in mode
    end else begin
        IQ_reg <= w0; // Capture data on clock edge
    end
end

assign IQ = IQ_reg;

buf g5(Q, IQ);
not g6(XQ, IQ);
buf g7(SO, IQ);

endmodule