module sha256_block(input clk,  
                     input rst,  
                     input [511:0] message,  
                     output reg [255:0] hash);  
                     
    reg [255:0] state;  
    reg [511:0] msg_schedule;  
   
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= 256'h0;  
            hash <= 256'h0;  
        end else begin  
            // Simplified process for demonstration purposes  
            msg_schedule <= message;  
            // Update state (simple XOR for illustration)  
            state <= state ^ msg_schedule[255:0];  
            hash <= state;  
        end  
    end  
endmodule