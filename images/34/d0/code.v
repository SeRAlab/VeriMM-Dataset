module png_compression(  
    input [7:0] pixel_in1,  
    input [7:0] pixel_in2,  
    output reg [7:0] compressed_out1,  
    output reg [7:0] compressed_out2  
);  
    always @(*) begin  
        compressed_out1 = pixel_in1;  
        compressed_out2 = pixel_in2 - pixel_in1;  
    end  
endmodule