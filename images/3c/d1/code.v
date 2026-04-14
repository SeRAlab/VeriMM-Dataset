module rle_encoder (  
    input [7:0] pixel_in,  
    input valid,  
    output reg [15:0] encoded_out,  
    output reg valid_out  
);  
    reg [7:0] current_pixel;  
    reg [3:0] run_length;  
    always @(posedge valid) begin  
        if (pixel_in == current_pixel) begin  
            if (run_length < 15) begin  
                run_length <= run_length + 1;  
            end  
        end else begin  
            encoded_out <= {run_length, current_pixel};  
            valid_out <= 1;  
            current_pixel <= pixel_in;  
            run_length <= 1;  
        end  
    end  
    always @(negedge valid) begin  
        valid_out <= 0;  
    end  
endmodule