module tcp_segmenter (  
    input wire clk,  
    input wire [31:0] data_in,  
    input wire [15:0] segment_size,  
    output reg [31:0] data_out,  
    output reg segment_valid  
);  
    reg [15:0] byte_count;  
    reg [31:0] temp_data;  
    integer i;  

    always @(posedge clk) begin  
        if (byte_count < segment_size) begin  
            temp_data[byte_count*8 +: 8] <= data_in[byte_count*8 +: 8];  
            byte_count <= byte_count + 1;  
        end else begin  
            data_out <= temp_data;  
            segment_valid <= 1;  
            byte_count <= 0;  
        end  
    end  

    always @(posedge clk) begin  
        if (segment_valid) begin  
            segment_valid <= 0;  
        end  
    end  
endmodule