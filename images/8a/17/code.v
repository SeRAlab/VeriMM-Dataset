module top_module(
    d_in, out_in, d_out, d_out2
    );input [7:0] d_in;
    input [7:0] out_in;
    
    output d_out;
    output [14:0] d_out2;
    assign d_out = d_in[7];
    assign d_out2 = {d_in[6:0],out_in[7:0]} ;
endmodule