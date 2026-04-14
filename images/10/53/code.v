module ofdm_transmitter (  
    input clk,  
    input reset,  
    input [7:0] data_in,  
    output reg [15:0] time_domain_out  
);  
    reg [7:0] freq_domain [0:7];  
    integer i;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            time_domain_out <= 16'b0;  
            for (i = 0; i < 8; i = i + 1)  
                freq_domain[i] <= 8'b0;  
        end else begin  
            // Simple IFFT operation: just add the input data for demonstration  
            for (i = 0; i < 8; i = i + 1)  
                freq_domain[i] <= data_in;  
            
            // Simple accumulation to simulate IFFT output  
            time_domain_out <= freq_domain[0] + freq_domain[1] + freq_domain[2] + freq_domain[3] +  
                               freq_domain[4] + freq_domain[5] + freq_domain[6] + freq_domain[7];  
        end  
    end  
endmodule