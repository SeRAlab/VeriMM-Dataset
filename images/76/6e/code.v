module top_module(
    input [15:0] A,
    input [15:0] B,
    input MODE,
    input CIN,
    output reg [15:0] Q
);always @(*) begin
        if (MODE == 0) begin
            Q = A + B + CIN;
        end else begin
            Q = A - B - CIN;
        end
    end

endmodule