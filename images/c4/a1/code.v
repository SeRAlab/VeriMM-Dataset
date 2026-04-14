module mux (
    input [7:0] in0,
    input [7:0] in1,
    input [7:0] in2,
    input [7:0] in3,
    input [1:0] sel,
    input en,
    output reg [7:0] out
);

always @(*) begin
    case(sel)
        2'b00: out = en ? in0 : 8'b0;
        2'b01: out = en ? in1 : 8'b0;
        2'b10: out = en ? in2 : 8'b0;
        2'b11: out = en ? in3 : 8'b0;
    endcase
end

endmodule