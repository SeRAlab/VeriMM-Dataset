module packet_filter(  
    input [7:0] packet_id,  
    output reg allowed  
);  
    always @(*) begin  
        if (packet_id[0] == 1'b0)  
            allowed = 1'b1; // Even ID  
        else  
            allowed = 1'b0; // Odd ID  
    end  
endmodule