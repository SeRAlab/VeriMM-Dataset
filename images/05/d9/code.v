module packet_filter (  
    input [4:0] packet,  
    input [4:0] rule0,  
    input [4:0] rule1,  
    input [4:0] rule2,  
    input [4:0] rule3,  
    input [4:0] rule4,  
    output reg allow  
);  
    always @(*) begin  
        if (packet == rule0 || packet == rule1 || packet == rule2 || packet == rule3 || packet == rule4)  
            allow = 1;  
        else  
            allow = 0;  
    end  
endmodule