module top_module(
    input rstn, clk, J, K,
    output reg Q,
    output Qn
);always @ (posedge clk, negedge rstn)
    begin
        if (!rstn)
            Q <= 1'b0;
        else
            case (Q)
                1'b0 : Q <= J;
                1'b1 : Q <= ~K;
            endcase
    end

    assign Qn = ~Q;
endmodule