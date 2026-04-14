module top_module(
    input [3:0] O,
    input [3:0] A,
    input C,
    output reg [3:0] S,
    output reg [3:0] D,
    output reg B
);always @(*) begin
    if (C == 1'b1) begin
        S = O + A;
        D = 4'b0;
        B = 1'b0;
    end else begin
        S = 4'b0;
        if (O < A) begin
            D = (O + 16) - A;
            B = 1'b1;
        end else begin
            D = O - A;
            B = 1'b0;
        end
    end
end

endmodule