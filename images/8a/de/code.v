module top_module(D, Q, C, R, S);input D, C, R, S;
    output Q;

    reg Q;

    always @(posedge C) begin
        if (R == 1'b1 && S == 1'b1) begin
            // Undefined behavior
        end else if (R == 1'b1) begin
            Q <= 1'b0;
        end else if (S == 1'b1) begin
            Q <= 1'b1;
        end else begin
            Q <= D;
        end
    end
endmodule