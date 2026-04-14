module jpeg_rle_compression (  
    input clk,  
    input rst,  
    input [7:0] pixel_in,  
    input valid,  
    output reg [7:0] run_count,  
    output reg [7:0] pixel_out,  
    output reg out_valid  
);  
    reg [7:0] current_pixel;  
    reg [7:0] count;  
    reg state; // 0: idle, 1: counting  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            current_pixel <= 0;  
            count <= 0;  
            run_count <= 0;  
            pixel_out <= 0;  
            out_valid <= 0;  
            state <= 0;  
        end else begin  
            if (valid) begin  
                if (state == 0) begin  
                    current_pixel <= pixel_in;  
                    count <= 1;  
                    state <= 1;  
                end else begin  
                    if (pixel_in == current_pixel) begin  
                        count <= count + 1;  
                    end else begin  
                        run_count <= count;  
                        pixel_out <= current_pixel;  
                        out_valid <= 1;  
                        current_pixel <= pixel_in;  
                        count <= 1;  
                    end  
                end  
            end  
            if (out_valid) begin  
                out_valid <= 0;  
            end  
        end  
    end  
endmodule