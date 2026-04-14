module top_module(
    input [3:0] A,
    input [3:0] B,
    input sub,
    output reg [1:0] Y
);reg [4:0] sum;

always @(*) begin
    if (sub) begin
        sum <= A - B;
    end else begin
        sum <= A + B;
    end
end

assign Y[0] = sum[0] | sum[1] | sum[2] | sum[3];
assign Y[1] = sum[4] ? 2'b10 : (sum[3] ? 2'b01 : 2'b00);

endmodule