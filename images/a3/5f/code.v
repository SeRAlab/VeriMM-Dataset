module top_module(inputA, inputB, control, out);parameter bits = 32;
    input [bits-1:0] inputA;
    input [bits-1:0] inputB;
    input control; 
    output [bits-1:0] out; 
    assign out= (control==1'b0) ?inputA:inputB;
endmodule