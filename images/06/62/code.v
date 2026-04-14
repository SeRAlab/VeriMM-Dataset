module ip_checksum_calc(  
    input [15:0] data_in,  
    input end_packet,  
    output reg [15:0] checksum_out  
);  
    reg [15:0] sum;  
    always @(*) begin  
        if (end_packet) begin  
            checksum_out = ~sum;  
        end else begin  
            sum = sum + data_in;  
        end  
    end  
endmodule