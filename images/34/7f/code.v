module packet_filter(  
    input [15:0] packet_in,  
    output reg packet_out  
);  
    always @(*) begin  
        if (packet_in[15:12] == 4'b1010)  
            packet_out = 1;  
        else  
            packet_out = 0;  
    end  
endmodule