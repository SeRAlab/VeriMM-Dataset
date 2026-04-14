module mac_address_filter(  
    input [47:0] eth_addr,  
    input [47:0] predefined_addr,  
    output reg match  
);  
    always @(*) begin  
        if (eth_addr == predefined_addr)  
            match = 1;  
        else  
            match = 0;  
    end  
endmodule