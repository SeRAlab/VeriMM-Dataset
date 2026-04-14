module DFFSR (output Q, input C, S, R, D);

    reg Q;

    always @(posedge C) begin
        if (R) begin
            Q <= 0;
        end else if (S) begin
            Q <= 1;
        end else begin
            Q <= D;
        end
    end

endmodule