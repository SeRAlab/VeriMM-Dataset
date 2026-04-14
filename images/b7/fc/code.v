module top_module(
    input A,
    input B,
    input Cin,
    input En,
    output reg Sum,
    output reg Cout
);always @(A or B or Cin or En) begin
    if (En == 1'b1) begin
        Sum  <= A ^ B ^ Cin;
        Cout <= (A & B) | (Cin & (A ^ B));
    end else begin
        Sum  <= 1'b0;
        Cout <= 1'b0;
    end
end

endmodule