module top_module(
    out, 
    in
);input [3: 0] in ;
    output [3:0] out ;
    reg [15:0] configure ;
    assign out[0] = configure[0]&in[0] | configure[1]&in[1] | configure[2]&in[2] | configure[3]&in[3] ;
    assign out[1] = configure[4]&in[0] | configure[5]&in[1] | configure[6]&in[2] | configure[7]&in[3] ;
    assign out[2] = configure[8]&in[0] | configure[9]&in[1] | configure[10]&in[2] | configure[11]&in[3] ;
    assign out[3] = configure[12]&in[0] | configure[13]&in[1] | configure[14]&in[2] | configure[15]&in[3] ;endmodule