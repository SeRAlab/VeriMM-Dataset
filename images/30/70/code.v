module noise_suppression #(parameter N = 4) (  
    input clk,  
    input rst,  
    input [7:0] noisy_signal,  
    output reg [7:0] clean_signal  
);  
    reg [7:0] last_valid_signal;  
    reg [N-1:0] stable_count;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            clean_signal <= 8'b0;  
            last_valid_signal <= 8'b0;  
            stable_count <= 0;  
        end else begin  
            if (noisy_signal == last_valid_signal) begin  
                stable_count <= stable_count + 1;  
                if (stable_count >= N) begin  
                    clean_signal <= noisy_signal;  
                end  
            end else begin  
                stable_count <= 0;  
            end  
            last_valid_signal <= clean_signal;  
        end  
    end  
endmodule