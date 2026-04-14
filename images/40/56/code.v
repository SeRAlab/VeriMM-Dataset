module jpeg_compressor(  
    input wire clk,  
    input wire enable,  
    input wire [7:0] pixel_in,  
    output reg [7:0] compressed_out  
);  
    reg [7:0] pixel_buffer [0:7];  
    reg [2:0] count;  
    reg [15:0] sum;  

    always @(posedge clk) begin  
        if (enable) begin  
            pixel_buffer[count] <= pixel_in;  
            count <= count + 1;  
            if (count == 3'b111) begin  
                sum = pixel_buffer[0] + pixel_buffer[1] + pixel_buffer[2] + pixel_buffer[3] +  
                      pixel_buffer[4] + pixel_buffer[5] + pixel_buffer[6] + pixel_buffer[7];  
                compressed_out <= sum >> 3;  
                count <= 0;  
            end  
        end  
    end  
endmodule