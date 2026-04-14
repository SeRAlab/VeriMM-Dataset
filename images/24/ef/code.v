module tcp_segmentation(input [15:0] data_in, output reg [3:0] seg_type);  
    always @(*) begin  
        if (data_in < 512)  
            seg_type = 4'b0001;  
        else if (data_in <= 1024)  
            seg_type = 4'b0010;  
        else  
            seg_type = 4'b0011;  
    end  
endmodule