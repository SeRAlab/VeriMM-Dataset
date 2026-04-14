module top_module(in,amt,out);input wire [7:0] in;
    input wire [3:0] amt; 
    output wire [15:0] out;


    assign out = in << amt ;

endmodule