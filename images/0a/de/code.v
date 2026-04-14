module packet_filter(  
    input [4:0] src_addr,  
    input [4:0] allowed_addr,  
    output reg permit  
);  
    always @(*) begin  
        if (src_addr == allowed_addr)  
            permit = 1;  
        else  
            permit = 0;  
    end  
endmodule