module packet_filter (  
    input [7:0] src_ip,  
    input [7:0] dest_ip,  
    output reg accepted  
);  
    always @(*) begin  
        if (src_ip >= 8'd192 && src_ip <= 8'd223)  
            accepted = 1'b1;  
        else  
            accepted = 1'b0;  
    end  
endmodule