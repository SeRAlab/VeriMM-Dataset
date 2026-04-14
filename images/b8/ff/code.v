module top_module(
    input A1_N,
    input A2_N,
    input B1,
    input B2,
    output reg X
);always @(*) begin
        if (A1_N==0 && A2_N==0) begin
            X = B1;
        end else if (A1_N==0 && A2_N==1) begin
            X = B2;
        end else if (A1_N==1 && A2_N==0) begin
            X = ~B1;
        end else if (A1_N==1 && A2_N==1) begin
            X = ~B2;
        end
    end

endmodule