module tcp_segment_classifier(  
    input [15:0] segment_length,  
    input [4:0] tcp_flags,  
    output reg [1:0] segment_type  
);  
    always @(*) begin  
        if (segment_length > 1500) begin  
            segment_type = 2'b00;  
        end else if (tcp_flags[0] == 1) begin  
            segment_type = 2'b01; // FIN  
        end else if (tcp_flags[1] == 1) begin  
            segment_type = 2'b10; // SYN  
        end else if (tcp_flags[2] == 1) begin  
            segment_type = 2'b11; // RST  
        end else begin  
            segment_type = 2'b00; // No segment type  
        end  
    end  
endmodule