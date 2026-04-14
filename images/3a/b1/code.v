module chacha20_core(  
    input wire clk,  
    input wire reset,  
    input wire start,  
    input wire [255:0] key,  
    input wire [63:0] nonce,  
    output reg [511:0] output_block,  
    output reg done  
);  

    reg [31:0] state [0:15];  
    integer i;  

    initial begin  
        done = 0;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            done <= 0;  
        end else if (start) begin  
            // Initialize state  
            state[0] <= 32'h61707865;  
            state[1] <= 32'h3320646e;  
            state[2] <= 32'h79622d32;  
            state[3] <= 32'h6b206574;  
            for (i = 0; i < 8; i = i + 1) begin  
                state[i + 4] <= key[i*32 +: 32];  
            end  
            state[12] <= nonce[31:0];  
            state[13] <= nonce[63:32];  

            // Perform quarter rounds (simplified for this task)  
            // In a full implementation, you'd repeat this for 20 rounds  
            // Here we just perform one set of quarter rounds for demonstration  
            for (i = 0; i < 4; i = i + 1) begin  
                // Quarter round operation (simplified)  
                state[i] <= state[i] + state[i + 1];  
                state[i + 2] <= {state[i + 2][15:0], state[i + 2][31:16]} ^ state[i];  
            end  

            // Prepare output block  
            output_block <= {state[0], state[1], state[2], state[3], state[4], state[5], state[6], state[7]};  
            done <= 1;  
        end  
    end  
endmodule