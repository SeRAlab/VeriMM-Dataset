module wallace_tree_multiplier (  
    input [3:0] a,  
    input [3:0] b,  
    output [7:0] product  
);  
    wire [3:0] pp [3:0]; // Partial products  
    wire [7:0] sum1, sum2;  
    wire [2:0] carry;  
   
    // Generate partial products  
    genvar i, j;  
    generate  
        for (i = 0; i < 4; i = i + 1) begin: pp_gen  
            for (j = 0; j < 4; j = j + 1) begin: pp_inner  
                assign pp[i][j] = a[i] & b[j];  
            end  
        end  
    endgenerate  
   
    // Level 1: Add partial products  
    assign sum1 = {4'b0000, pp[0]} + {3'b000, pp[1], 1'b0} + {2'b00, pp[2], 2'b00};  
   
    // Level 2: Add intermediate results  
    assign product = sum1 + {1'b0, pp[3], 4'b0000};  
   
endmodule