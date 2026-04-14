module packet_filter(  
    input [3:0] protocol,  
    input [3:0] port,  
    output reg allow  
);  
    always @(*) begin  
        if (protocol == 4'b0001 && (port >= 4'b0001 && port <= 4'b0010))  
            allow = 1;  
        else  
            allow = 0;  
    end  
endmodule