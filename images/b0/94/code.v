module top_module(
    input [3:0] A,
    input [3:0] B,
    input SEL,
    input ADD,
    output reg [3:0] OUT
);always @(*) begin
    if(SEL == 0) begin
        OUT = A;
    end
    else if(SEL == 1 && ADD == 0) begin
        OUT = B;
    end
    else if(SEL == 1 && ADD == 1) begin
        OUT = A + B;
    end
end

endmodule