module hmac_simple(  
    input [127:0] key,  
    input [127:0] message,  
    output [127:0] hmac  
);  
    wire [127:0] inner_hash;  
    wire [127:0] outer_hash;  
  
    assign inner_hash = ~ (key ^ message);  // Simple inner hash operation  
    assign outer_hash = ~ (key ^ inner_hash); // Simple outer hash operation  
    assign hmac = outer_hash;  
  
endmodule