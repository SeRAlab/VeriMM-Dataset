module noise_suppression(input [4:0] noise_in,  
                         input reset,  
                         input clk,  
                         output reg [4:0] clean_out);  
                         
    reg [4:0] prev_out;  
    reg [4:0] count;  
    integer change_count;  
     
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            clean_out <= 5'b00000;  
            prev_out <= 5'b00000;  
            change_count <= 0;  
        end else begin  
            change_count = 0;  
            if (noise_in != prev_out) begin  
                // Count the number of changes in the input  
                if (noise_in[0] != prev_out[0]) change_count = change_count + 1;  
                if (noise_in[1] != prev_out[1]) change_count = change_count + 1;  
                if (noise_in[2] != prev_out[2]) change_count = change_count + 1;  
                if (noise_in[3] != prev_out[3]) change_count = change_count + 1;  
                if (noise_in[4] != prev_out[4]) change_count = change_count + 1;  
            end  
            
            if (change_count < 3) begin  
                clean_out <= prev_out;  
            end else begin  
                clean_out <= noise_in;  
            end  
            prev_out <= clean_out;  
        end  
    end  
endmodule