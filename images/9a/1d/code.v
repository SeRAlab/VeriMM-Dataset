module top_module(
    input [3:0] sw,
    output reg dis=0,
    output reg [6:0] seg
    );always @(sw)
    begin
    
        case(sw)
            0:seg=63;
            1:seg=6;
            2:seg=91;
            3:seg=79;
            4:seg=102;
            5:seg=109;
            6:seg=125;
            7:seg=7;
            8:seg=127;
            9:seg=111;
            10:seg=119;
            11:seg=124;
            12:seg=88;
            13:seg=94;
            14:seg=121;
            15:seg=113;
        endcase
        seg[0]=(!seg[0]);
        seg[1]=(!seg[1]);
        seg[2]=(!seg[2]);
        seg[3]=(!seg[3]);
        seg[4]=(!seg[4]);
        seg[5]=(!seg[5]);
        seg[6]=(!seg[6]);
        
    end
endmodule