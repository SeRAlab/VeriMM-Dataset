module top_module(
    input [3:0] A,
    input [3:0] B,
    input EN,
    output reg [3:0] C,
    output reg OV
);always @(*) begin
    if(EN) begin
        C = A + B;
        if(C > 15) begin
            OV = 1;
            C = C - 16;
        end else begin
            OV = 0;
        end
    end else begin
        C = 0;
        OV = 0;
    end
end

endmodule