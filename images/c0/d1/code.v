module mux2_to_1(in1, in2 , out, sel);
input [4:0] in1, in2;
input sel;
output [4:0] out;
reg [4:0] out;
always@(sel or in1 or in2)
begin
    case(sel)
        0   : out = in1;
        1   : out = in2;
        default: out = in1;
    endcase
end
endmodule