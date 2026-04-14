module mux_8to1(
    input wire in0,
    input wire in1,
    input wire in2,
    input wire in3,
    input wire in4,
    input wire in5,
    input wire in6,
    input wire in7,
    input wire [2:0] sel,
    output wire out
    );

assign out = (sel == 3'b000) ? in0 :
             (sel == 3'b001) ? in1 :
             (sel == 3'b010) ? in2 :
             (sel == 3'b011) ? in3 :
             (sel == 3'b100) ? in4 :
             (sel == 3'b101) ? in5 :
             (sel == 3'b110) ? in6 :
                               in7;

endmodule