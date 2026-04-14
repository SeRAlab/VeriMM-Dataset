module chacha_add_sub (  
    input wire [31:0] a,  
    input wire [31:0] b,  
    input wire control,  
    output reg [31:0] result  
);  

always @(*) begin  
    if (control == 1'b0)  
        result = a + b;  // Addition  
    else  
        result = a - b;  // Subtraction  
end  
endmodule