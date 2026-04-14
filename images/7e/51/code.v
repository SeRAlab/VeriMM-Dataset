module mux_16to1(
    input wire in0,
    input wire in1,
    input wire in2,
    input wire in3,
    input wire in4,
    input wire in5,
    input wire in6,
    input wire in7,
    input wire in8,
    input wire in9,
    input wire in10,
    input wire in11,
    input wire in12,
    input wire in13,
    input wire in14,
    input wire in15,
    input wire [3:0] sel,
    output wire out
    );

assign out = (sel == 4'b0000) ? in0 :
             (sel == 4'b0001) ? in1 :
             (sel == 4'b0010) ? in2 :
             (sel == 4'b0011) ? in3 :
             (sel == 4'b0100) ? in4 :
             (sel == 4'b0101) ? in5 :
             (sel == 4'b0110) ? in6 :
             (sel == 4'b0111) ? in7 :
             (sel == 4'b1000) ? in8 :
             (sel == 4'b1001) ? in9 :
             (sel == 4'b1010) ? in10 :
             (sel == 4'b1011) ? in11 :
             (sel == 4'b1100) ? in12 :
             (sel == 4'b1101) ? in13 :
             (sel == 4'b1110) ? in14 :
                                in15;

endmodule