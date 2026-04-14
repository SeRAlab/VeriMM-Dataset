module top_module(input J, K, C, R, E, output reg Q, output reg Qn);always @(posedge C) begin
        if (E == 1'b0) begin
            Q <= 1'b0;
            Qn <= 1'b1;
        end else if (R == 1'b0) begin
            Q <= 1'b0;
            Qn <= 1'b1;
        end else if (J == 1'b1 && K == 1'b1) begin
            Q <= ~Q;
            Qn <= ~Qn;
        end else if (J == 1'b1 && K == 1'b0) begin
            Q <= 1'b1;
            Qn <= 1'b0;
        end else if (J == 1'b0 && K == 1'b1) begin
            Q <= 1'b0;
            Qn <= 1'b1;
        end
    end
endmodule