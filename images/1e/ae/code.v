module nearest_neighbor_interpolation(  
    input [1:0] pixel_in,  
    output reg [3:0] pixel_out  
);  
    always @(*) begin  
        case (pixel_in)  
            2'b00: pixel_out = 4'b0000; // Interpolate to 4 pixels of 0  
            2'b01: pixel_out = 4'b0001; // Interpolate to 4 pixels of 1  
            2'b10: pixel_out = 4'b0010; // Interpolate to 4 pixels of 2  
            2'b11: pixel_out = 4'b0011; // Interpolate to 4 pixels of 3  
            default: pixel_out = 4'b0000;  
        endcase  
    end  
endmodule