module barrel_shifter_2bit(input [1:0] in, input ctrl, output [1:0] out);  
    assign out = (ctrl == 0) ? {in[0], in[1]} : {in[1], in[0]};  
endmodule