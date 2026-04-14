module top_module(input CLK ,input [11:0]max,  output reg[7:0]number = 0, input[15:0]countB );reg counter = 0;
always@ (posedge CLK)
    begin
    if ((countB/10) <= 0)
        counter = 0;
    else
        counter = 1;
    case(counter)
        0:  
            number <= 8'b11000000; 
        1:
            number <= 8'b11111001; 
        default:
            counter = 1;
        endcase       
    end

endmodule