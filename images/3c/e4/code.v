module ARQ_System (  
    input clk,  
    input reset,  
    input [3:0] data_in,  
    input request_retransmit,  
    output reg [3:0] data_out,  
    output reg parity_out,  
    output reg error_detected  
);  

reg [3:0] data_reg;  
reg parity_reg;  

always @(posedge clk or posedge reset) begin  
    if (reset) begin  
        data_reg <= 4'b0000;  
        parity_reg <= 1'b0;  
        data_out <= 4'b0000;  
        parity_out <= 1'b0;  
        error_detected <= 1'b0;  
    end else begin  
        // Store data and calculate parity
        data_reg <= data_in;  
        parity_reg <= ^data_reg; // Calculate parity bit (even parity)  
        
        if (request_retransmit) begin  
            // If retransmission is requested
            data_out <= data_reg;  
            parity_out <= parity_reg;  
            error_detected <= 1'b1;  
        end else begin  
            // Send data and parity when no error
            data_out <= data_reg;  
            parity_out <= parity_reg;  
            error_detected <= 1'b0;  
        end  
    end  
end  

endmodule