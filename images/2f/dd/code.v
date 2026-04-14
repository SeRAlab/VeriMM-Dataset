module mac_address_filter(  
    input [47:0] dest_mac,    // Destination MAC address from Ethernet frame  
    input [47:0] filter_mac,  // Filter MAC address  
    output reg match          // Match signal  
);  
    always @(*) begin  
        if(dest_mac == filter_mac)  
            match = 1'b1;  
        else  
            match = 1'b0;  
    end  
endmodule