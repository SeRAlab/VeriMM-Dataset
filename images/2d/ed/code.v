module mac_filter(  
    input [47:0] input_mac,  
    output reg match  
);  
    // Predefined MAC address (for example, 00:11:22:33:44:55)  
    reg [47:0] mac_address = 48'h001122334455;  

    always @(*) begin  
        if (input_mac == mac_address)  
            match = 1;  
        else  
            match = 0;  
    end  
endmodule