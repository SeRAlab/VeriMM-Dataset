module top_module(
    input [3:0] A,
    input [3:0] B,
    output reg [7:0] P
);reg [7:0] temp;

always @(*) begin
    temp = A * B;
    P[7:0] = temp[7:0];
    P[15:8] = temp[15:8];
end

endmodule