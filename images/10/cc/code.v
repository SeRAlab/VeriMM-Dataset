module wallace_tree_adder (  
    input [3:0] A,  
    input [3:0] B,  
    output [4:0] SUM  
);  
    wire [7:0] prod;  
    assign prod = A * B;  
    assign SUM = prod[4:0];  
endmodule