module tcp_segmenter(  
    input clk,  
    input rst_n,  
    input new_data,  
    input [31:0] data_in,  
    input [15:0] mss,  
    output reg [31:0] segment_out,  
    output reg segment_valid  
);  
    reg [31:0] buffer;  
    reg [15:0] count;  
    reg [15:0] data_length;  

    always @(posedge clk or negedge rst_n) begin  
        if (!rst_n) begin  
            buffer <= 32'b0;  
            count <= 16'b0;  
            data_length <= 16'b0;  
            segment_valid <= 1'b0;  
        end else begin  
            if (new_data) begin  
                buffer <= data_in;  
                data_length <= data_length + 1;  
                count <= 0;  
            end  

            if (count < data_length) begin  
                segment_out <= buffer[count * 32 +: 32];  
                segment_valid <= 1'b1;  
                count <= count + 1;  
            end else begin  
                segment_valid <= 1'b0;  
            end  
        end  
    end  
endmodule