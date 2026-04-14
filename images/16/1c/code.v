module hmac(input [63:0] key,  
            input [63:0] message,  
            output [63:0] hmac_out);  

    assign hmac_out = key ^ message;  
endmodule