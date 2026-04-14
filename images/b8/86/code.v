module top_module(input [3:0] in0, in1, in2, in3,
                     input [1:0] sel,
                     input en,
                     output reg [3:0] out);always @(*) begin
        case (sel)
            2'b00: out = en ? in0 : 4'b0000;
            2'b01: out = en ? in1 : 4'b0000;
            2'b10: out = en ? in2 : 4'b0000;
            2'b11: out = en ? in3 : 4'b0000;
        endcase
    end

endmodule