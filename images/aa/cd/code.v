module top_module(CLK, EN, TE, D, Q);input CLK, EN, TE, D;
    output Q;

    reg Q_int;
    wire ENCLK;

    assign ENCLK = (EN & TE);

    always @(posedge ENCLK) begin
        if (EN) begin
            Q_int <= D;
        end
    end

    assign Q = Q_int;

endmodule