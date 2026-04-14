module full_adder(
    input a,
    input b,
    input cin,

    output reg sum,
    output reg cout
);

always @(*)
begin
    sum = a ^ b ^ cin;
    cout = (a & b) | (b & cin) | (a & cin);
end

endmodule