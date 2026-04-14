module top_module(
    input A1_N,
    input A2_N,
    input B1,
    input B2,
    output reg Y
);always @(*) begin
    if (A1_N == 0 && A2_N == 0) begin
        Y <= B1;
    end else if (A1_N == 0 && A2_N == 1) begin
        Y <= B2;
    end else if (A1_N == 1 && A2_N == 0) begin
        Y <= B1;
    end else if (A1_N == 1 && A2_N == 1) begin
        Y <= B2;
    end
end

endmodule