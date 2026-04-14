module top_module(IN0, IN1, SEL, MUX_OUT);input [31:0] IN0, IN1;
    input SEL;
    output [31:0] MUX_OUT;
    reg [31:0] MUX_OUT;
    
    always @ (*)
        case(SEL)
            0: MUX_OUT = IN0;
            1: MUX_OUT = IN1;
        endcase
endmodule