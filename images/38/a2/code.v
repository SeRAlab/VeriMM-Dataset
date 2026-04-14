module rs_encoder (  
    input clk,  
    input rst,  
    input [3:0] data_in,  
    input start,  
    output reg [7:0] encoded_out,  
    output reg done  
);  
    reg [1:0] state;  
    reg [3:0] temp_data;  
  
    // State encoding  
    localparam IDLE = 2'b00,  
               PROCESS = 2'b01,  
               OUTPUT = 2'b10;  
  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            encoded_out <= 8'b0;  
            done <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        temp_data <= data_in;  
                        state <= PROCESS;  
                        done <= 0;  
                    end  
                end  
                PROCESS: begin  
                    // Simplified encoding logic for demonstration  
                    encoded_out <= {temp_data, temp_data[3:2] ^ temp_data[1:0]};  
                    state <= OUTPUT;  
                end  
                OUTPUT: begin  
                    done <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule