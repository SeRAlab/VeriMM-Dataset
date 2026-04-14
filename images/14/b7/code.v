module tcp_segmenter #(parameter PACKET_SIZE = 8) (  
    input clk,  
    input data_valid,  
    input [31:0] data_in,  
    output reg [31:0] packet_out,  
    output reg packet_valid  
);  
    reg [31:0] buffer;  
    reg [3:0] byte_count;  

    always @(posedge clk) begin  
        if (data_valid) begin  
            buffer <= data_in;  
            byte_count <= 0;  
        end  
        
        if (byte_count < PACKET_SIZE) begin  
            packet_out[byte_count*4 +: 4] <= buffer[byte_count*4 +: 4];  
            byte_count <= byte_count + 1;  
        end  
        
        if (byte_count == PACKET_SIZE) begin  
            packet_valid <= 1;  
            byte_count <= 0;  
        end else begin  
            packet_valid <= 0;  
        end  
    end  
endmodule