module aes_round (  
    input wire clk,  
    input wire rst,  
    input wire [127:0] state_in,  
    input wire start,  
    output reg [127:0] state_out,  
    output reg done  
);  

    reg [127:0] state;  
    reg [3:0] current_state;  
    parameter IDLE = 4'b0000, SUBBYTES = 4'b0001, SHIFTROWS = 4'b0010, MIXCOLUMNS = 4'b0011, OUTPUT = 4'b0100;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= 128'b0;  
            current_state <= IDLE;  
            done <= 1'b0;  
        end else begin  
            case (current_state)  
                IDLE: if (start) begin  
                    state <= state_in;  
                    current_state <= SUBBYTES;  
                end  
                SUBBYTES: begin  
                    // Example SubBytes operation (simple inversion for demonstration)  
                    state <= {state[127:120] ^ 8'hFF, state[119:112] ^ 8'hFF, state[111:104] ^ 8'hFF, state[103:96] ^ 8'hFF,  
                               state[95:88] ^ 8'hFF, state[87:80] ^ 8'hFF, state[79:72] ^ 8'hFF, state[71:64] ^ 8'hFF,  
                               state[63:56] ^ 8'hFF, state[55:48] ^ 8'hFF, state[47:40] ^ 8'hFF, state[39:32] ^ 8'hFF,  
                               state[31:24] ^ 8'hFF, state[23:16] ^ 8'hFF, state[15:8] ^ 8'hFF, state[7:0] ^ 8'hFF};  
                    current_state <= SHIFTROWS;  
                end  
                SHIFTROWS: begin  
                    // Example ShiftRows operation  
                    state <= {state[127:120], state[87:80], state[47:40], state[7:0],  
                               state[119:112], state[79:72], state[39:32], state[95:88],  
                               state[111:104], state[71:64], state[31:24], state[55:48],  
                               state[103:96], state[63:56], state[23:16], state[15:8]};  
                    current_state <= MIXCOLUMNS;  
                end  
                MIXCOLUMNS: begin  
                    // Example MixColumns operation (simple XOR for demonstration)  
                    state <= {state[127:120] ^ state[119:112], state[119:112] ^ state[111:104], state[111:104] ^ state[103:96], state[103:96] ^ state[127:120],  
                               state[95:88] ^ state[87:80], state[87:80] ^ state[79:72], state[79:72] ^ state[71:64], state[71:64] ^ state[95:88],  
                               state[63:56] ^ state[55:48], state[55:48] ^ state[47:40], state[47:40] ^ state[39:32], state[39:32] ^ state[63:56],  
                               state[31:24] ^ state[23:16], state[23:16] ^ state[15:8], state[15:8] ^ state[7:0], state[7:0] ^ state[31:24]};  
                    current_state <= OUTPUT;  
                end  
                OUTPUT: begin  
                    state_out <= state;  
                    done <= 1'b1;  
                    current_state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule