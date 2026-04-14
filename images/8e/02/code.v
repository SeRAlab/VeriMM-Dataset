module top_module(input R, input S, input E, output Q, output Qbar);wire RE, ES;
    assign RE = R&E;
    assign ES = E&S;
    assign #1 Q = ~(Qbar|RE);
    assign #1 Qbar = ~(Q|ES); 
endmodule