module combinational_circuit (
    input A1,
    input A2,
    input B1_N,
    output reg Y
);

always @* begin
    if (A1 && A2) begin
        Y = 1;
    end else if (A1 && !A2) begin
        Y = 0;
    end else if (!A1 && A2) begin
        Y = 0;
    end else begin
        Y = B1_N;
    end
end

endmodule