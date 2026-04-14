module packet_filter(  
    input [3:0] packet_type,  
    input enable,  
    output reg allowed  
);  
    always @(*) begin  
        if (enable) begin  
            if (packet_type == 4'b0001)  
                allowed = 1'b1;  
            else  
                allowed = 1'b0;  
        end else begin  
            allowed = 1'b0;  
        end  
    end  
endmodule