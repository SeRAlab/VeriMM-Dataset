module top_module(CLK, D, RST, Q);input CLK;
    input D;
    input RST;
    output Q;

    reg Q_next;

    always @(negedge CLK) begin
        if (RST == 1'b0) begin
            Q_next <= 1'b0;
        end else begin
            Q_next <= D;
        end
    end

    assign Q = Q_next;

endmodule