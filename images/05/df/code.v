module viterbi_decoder (  
    input clk,  
    input rst,  
    input [1:0] encoded_bits,  
    output reg [1:0] decoded_bits,  
    output reg [3:0] state_metrics  
);  
    reg [2:0] state;  
    reg [3:0] next_state_metrics [0:3];  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= 3'b000;  
            decoded_bits <= 2'b00;  
            state_metrics <= 4'b0000;  
        end else begin  
            // Update state based on encoded_bits  
            state_metrics[state] = state_metrics[state] + (encoded_bits == 2'b00 ? 1 : 0);  
            // Example: simple state transition logic  
            case (encoded_bits)  
                2'b00: begin  
                    state <= state;  
                    decoded_bits <= 2'b00;  
                end  
                2'b01: begin  
                    state <= state + 1;  
                    decoded_bits <= 2'b01;  
                end  
                2'b10: begin  
                    state <= state + 2;  
                    decoded_bits <= 2'b10;  
                end  
                2'b11: begin  
                    state <= state + 3;  
                    decoded_bits <= 2'b11;  
                end  
            endcase  
        end  
    end  
endmodule