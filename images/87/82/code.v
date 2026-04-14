module top_module(a, b, ab);input [16:0] a, b;
    output [16:0] ab;
    

    wire [16:0] a, b;
    wire [16:0] ab;
    wire[31:0] multresult;
    

    assign multresult = a[15:0] * b[15:0]; 
    assign ab[15:0] = multresult[23:8]; 
    assign ab[16] = a[16] ^ b[16]; 
    
    

endmodule