module tcp_segmentation (  
    input [15:0] data_in,  
    input segment_enable,  
    output reg [7:0] data_out1,  
    output reg [7:0] data_out2  
);  
    always @(*) begin  
        if (segment_enable) begin  
            data_out1 = data_in[15:8];  
            data_out2 = data_in[7:0];  
        end else begin  
            data_out1 = data_in[15:8];  
            data_out2 = data_in[7:0];  
        end  
    end  
endmodule