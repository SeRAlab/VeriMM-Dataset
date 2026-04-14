module HMAC (  
    input [63:0] key,  
    input [63:0] message,  
    output reg [63:0] hmac  
);  
    reg [63:0] inner_pad;  
    reg [63:0] outer_pad;  
    reg [63:0] hash;  
    
    always @(*) begin  
        inner_pad = key ^ 64'h3636363636363636;  
        outer_pad = key ^ 64'h5c5c5c5c5c5c5c5c;  
        
        // Simple hash function combining message and inner pad
        hash = inner_pad ^ message;  
        
        // Final HMAC output combining outer pad and hash
        hmac = outer_pad ^ hash;  
    end  
endmodule