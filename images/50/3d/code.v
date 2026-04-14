module top_module(
    input [3:0] A,
    input [3:0] B,
    input mode,
    input cin,
    output [3:0] sum,
    output cout
);reg [3:0] temp_sum;
reg temp_cout;

always @(*) begin
    if (mode == 1) begin // subtraction mode
        temp_sum = A - B - cin;
        temp_cout = ~(A[3] ^ B[3]) & (temp_sum[3] ^ B[3]);
    end else begin // addition mode
        temp_sum = A + B + cin;
        temp_cout = (A[3] & B[3]) | ((A[3] | B[3]) & ~temp_sum[3]);
    end
end

assign sum = temp_sum;
assign cout = temp_cout;

endmodule