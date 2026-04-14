module top_module(input [3:0] A, input [3:0] B, input C, output [3:0] S);wire [3:0] sum;
    wire [3:0] diff;
    
    //summing A and B
    assign sum = A + B;
    
    //finding the difference between A and B
    assign diff = A - B;
    
    //outputting the sum or difference based on control input C
    assign S = C ? diff : sum;
    
endmodule