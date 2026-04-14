module top_module(\in[3] ,\in[2] ,\in[1] ,\in[0] ,cin, lut4_out, cout);parameter [15:0] LUT  = 16'd0;
    parameter [0: 0] MODE = 0;

    input  [0:0] \in[3] ;
    input  [0:0] \in[2] ;
    input  [0:0] \in[1] ;
    input  [0:0] \in[0] ;
    input  [0:0] cin;
    output [0:0] lut4_out;
    output [0:0] cout;

    
    
    wire [3:0] li = (MODE == 1'b1) ?
        {\in[3] ,cin,    \in[1] ,\in[0] } :
        {\in[3] ,\in[2] ,\in[1] ,\in[0] };

    
    wire [7:0] s1 = li[0] ?
        {LUT[14], LUT[12], LUT[10], LUT[8], LUT[6], LUT[4], LUT[2], LUT[0]} :
        {LUT[15], LUT[13], LUT[11], LUT[9], LUT[7], LUT[5], LUT[3], LUT[1]};

    wire [3:0] s2 = li[1] ?
        {s1[6], s1[4], s1[2], s1[0]} :
        {s1[7], s1[5], s1[3], s1[1]};

    wire [1:0] s3 = li[2] ?
        {s2[2], s2[0]} :
        {s2[3], s2[1]};

    assign lut4_out = li[3] ? s3[0] : s3[1];

    
    assign cout = s2[2] ? cin : s2[3];

    
    
    specify
        (\in[0] => lut4_out) = 0;
        (\in[1] => lut4_out) = 0;
        (\in[2] => lut4_out) = 0;
        (\in[3] => lut4_out) = 0;
        (cin => lut4_out) = 0;
        (\in[0] => cout) = 0;
        (\in[1] => cout) = 0;
        (\in[2] => cout) = 0;
        (\in[3] => cout) = 0;
        (cin => cout) = 0;
    endspecify

endmodule