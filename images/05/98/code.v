module rs_encoder(  
    input clk,  
    input reset,  
    input [3:0] data_in,  
    output reg [6:0] codeword_out,  
    input start,  
    output reg done  
);  
    reg [3:0] state;  
    reg [3:0] data_reg;  
    parameter IDLE = 0, ENCODE = 1, OUTPUT = 2;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            codeword_out <= 7'b0;  
            done <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        data_reg <= data_in;  
                        state <= ENCODE;  
                        done <= 0;  
                    end  
                end  
                ENCODE: begin  
                    // Simple encoding logic (parity bits added for illustration)  
                    codeword_out[6:4] <= data_reg[3:1];  
                    codeword_out[3:0] <= data_reg[3:0];  
                    codeword_out[6] <= data_reg[0] ^ data_reg[1];  
                    codeword_out[5] <= data_reg[1] ^ data_reg[2];  
                    codeword_out[4] <= data_reg[2] ^ data_reg[3];  
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