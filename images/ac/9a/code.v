module barrel_shifter_32bit (y, a, shamt, dir);
   input [31:0] a;
   input [4:0] shamt;
   input dir;
   output [31:0] y;
   
   assign y = dir ? (a >> shamt) : (a << shamt);
   
endmodule