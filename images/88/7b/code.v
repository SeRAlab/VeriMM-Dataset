module top_module(E, SE, CK, ECK, Q);input E, SE, CK, ECK;
    output Q;
    reg Q;

    always @(posedge ECK) begin
        if (E == 1'b1 && SE == 1'b0) begin
            Q <= CK;
        end
        else if (E == 1'b0) begin
            Q <= Q;
            if (ECK == 1'b1) begin
                Q <= CK;
            end
        end
        else if (SE == 1'b1) begin
            if (ECK == 1'b1) begin
                Q <= 1'b1;
            end
        end
    end
endmodule