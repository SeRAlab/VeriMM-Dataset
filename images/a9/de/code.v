module top_module(
    input [3:0] A,
    input [3:0] B,
    input [3:0] C,
    input [3:0] D,
    input E,
    output reg [3:0] Q
);always @ (A or B or C or D or E) begin
    if (E == 1'b1) begin
        Q <= A;
    end
    else begin
        Q <= D;
    end
end

endmodule