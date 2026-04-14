module top_module(
    input I0, I1, I2, I3, I4, I5, I6, I7, EN,
    input [2:0] SEL,
    output Y
    );reg y;
    
    always@(*)
        if(EN)begin
            y = (SEL == 0)?  I0 : (SEL == 1)? I1 : (SEL == 2)? I2 : (SEL == 3)? 
            I3 : (SEL == 4)? I4 : (SEL == 5)? I5 : (SEL == 6)? I6 : I7 ;
        end
    
    assign Y = y;endmodule