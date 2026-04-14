module mux_4to1_8bit (out, in0, in1, in2, in3, sel);
   input [7:0] in0, in1, in2, in3;
   input [1:0] sel;
   output [7:0] out;
   
   reg [7:0] out;

always @(*) begin
    case (sel)
        2'b00: out = in0;
        2'b01: out = in1;
        2'b10: out = in2;
        2'b11: out = in3;
        default: out = 8'b0;
    endcase
end

endmodule