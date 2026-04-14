module wallace_tree_adder (
    input [4:0] a,
    input [4:0] b,
    output [7:0] sum
);
    wire [4:0] p; // Partial products
    wire [4:0] g; // Grouped bits
    
    assign p = a & {5{b[0]}}; // AND with b[0]
    assign g = a & {5{b[1]}}; // AND with b[1]
    
    // Summing up in Wallace tree style
    wire [4:0] s1;
    wire c1;
    assign {c1, s1} = p + g; // First stage sum
    
    wire [4:0] s2;
    wire c2;
    assign {c2, s2} = s1 + (a & {5{b[2]}}); // Second stage sum
    
    wire [4:0] s3;
    wire c3;
    assign {c3, s3} = s2 + (a & {5{b[3]}}); // Third stage sum
    
    wire [4:0] s4;
    wire c4;
    assign {c4, s4} = s3 + (a & {5{b[4]}}); // Fourth stage sum
    
    assign sum = {c4, s4}; // Final output
    
endmodule