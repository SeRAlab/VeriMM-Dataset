module top_module(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    input Clk,
    output [3:0] S,
    output Cout
);reg [3:0] sum;

always @(posedge Clk) begin
    if (Cin) begin
        sum <= A + B + 1;
    end else begin
        sum <= A + B;
    end
end

assign S = sum;
assign Cout = sum[4];

endmodule