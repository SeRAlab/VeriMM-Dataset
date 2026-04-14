module viterbi_decoder (  
    input clk,  
    input rst,  
    input [1:0] received_bits,  
    output reg [1:0] decoded_bits,  
    output reg valid_output  
);  
    // State declarations  
    reg [1:0] state;  
    reg [1:0] next_state;  
    reg [6:0] path_mem [0:3]; // Memory for path metrics  
    integer i;  

    // State encoding  
    parameter S0 = 2'b00,  
              S1 = 2'b01,  
              S2 = 2'b10,  
              S3 = 2'b11;  

    // Initialize path metrics  
    initial begin  
        for (i = 0; i < 4; i = i + 1) begin  
            path_mem[i] = 7'b1111111; // Initial high metrics  
        end  
    end  

    // State transition logic  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= S0;  
            valid_output <= 0;  
        end else begin  
            state <= next_state;  
            valid_output <= 1;  
            // Decode logic and path metrics update  
            // (simplified for this example)  
            if (received_bits == 2'b00) begin  
                decoded_bits <= 2'b00;  
            end else if (received_bits == 2'b01) begin  
                decoded_bits <= 2'b01;  
            end else if (received_bits == 2'b10) begin  
                decoded_bits <= 2'b10;  
            end else begin  
                decoded_bits <= 2'b11;  
            end  
        end  
    end  
    
    // Next state logic  
    always @(*) begin  
        case (state)  
            S0: next_state = (received_bits == 2'b00) ? S0 : S1;  
            S1: next_state = (received_bits == 2'b10) ? S2 : S3;  
            S2: next_state = S0;  
            S3: next_state = S1;  
            default: next_state = S0;  
        endcase  
    end  
endmodule