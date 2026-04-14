module top_module(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    input reset,
    input clk,
    output reg [3:0] S,
    output reg Cout
);always @(posedge clk) begin
        if(reset) begin
            S <= 4'b0000;
            Cout <= 1'b0;
        end else begin
            {Cout, S} <= A + B + Cin;
        end
    end

endmodule