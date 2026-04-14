module mux_4to1(
    input [3:0] in1,
    input [3:0] in2,
    input [3:0] in3,
    input [3:0] in4,
    input sel1,
    input sel2,
    output reg [3:0] out_always
);

always @(*) begin
    if(sel1 == 0 && sel2 == 0) begin
        out_always = in1;
    end
    else if(sel1 == 0 && sel2 == 1) begin
        out_always = in2;
    end
    else if(sel1 == 1 && sel2 == 0) begin
        out_always = in3;
    end
    else begin
        out_always = in4;
    end
end

endmodule