module simplified_md5(input clk,  
                       input reset,  
                       input [63:0] data_in,  
                       input start,  
                       output reg [127:0] hash_out,  
                       output reg done);  
                       
    reg [63:0] padded_data;  
    reg [127:0] temp_hash;  
    reg [3:0] state;  
    
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            temp_hash <= 128'h0;  
            done <= 0;  
            state <= 0;  
        end else begin  
            case (state)  
                0: if (start) begin  
                        // Simple padding and hash initialization  
                        padded_data <= {data_in, 64'h0};  
                        temp_hash <= 128'h0123456789abcdef0123456789abcdef;  
                        state <= 1;  
                    end  
                1: begin  
                        // Simple hash operation (mockup)  
                        temp_hash <= temp_hash + padded_data;  
                        state <= 2;  
                    end  
                2: begin  
                        hash_out <= temp_hash;  
                        done <= 1;  
                        state <= 0;  
                    end  
            endcase  
        end  
    end  
endmodule