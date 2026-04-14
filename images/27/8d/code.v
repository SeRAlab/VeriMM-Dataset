module mux4to1 (  
    input wire [3:0] I, // 4 inputs  
    input wire [1:0] S, // 2-bit select input  
    output wire Y // output  
);  
    assign Y = (S == 2'b00) ? I[0] :  
               (S == 2'b01) ? I[1] :  
               (S == 2'b10) ? I[2] :  
               I[3]; // default case for S == 2'b11  
endmodule