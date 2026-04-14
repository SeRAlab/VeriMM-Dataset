module mux4to1 (  
    input wire [3:0] D,  // Data inputs  
    input wire [1:0] S,  // Select inputs  
    output wire Y       // Output  
);  
    assign Y = (S == 2'b00) ? D[0] :  
               (S == 2'b01) ? D[1] :  
               (S == 2'b10) ? D[2] :  
               D[3];  // Default case for S == 2'b11  
endmodule