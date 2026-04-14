module wallace_tree_adder(  
    input [3:0] A,  
    input [3:0] B,  
    output [4:0] SUM  
);  
    wire [7:0] product;  
    assign product = A * B;  
    assign SUM = product[4:0];  
endmodule