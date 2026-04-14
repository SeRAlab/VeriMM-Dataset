module full_adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,

    output [7:0] sum,
    output cout
);

reg [8:0] temp;

always @(*)
begin
  temp = a + b + cin;
  sum = temp[7:0];
  cout = temp[8];
end

endmodule