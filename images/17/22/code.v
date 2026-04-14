module chacha20_core(  
    input wire clk,  
    input wire reset,  
    input wire start,  
    input wire [255:0] key,  
    input wire [63:0] nonce,  
    input wire [31:0] counter,  
    output reg [63:0] output_data,  
    output reg ready  
);  
    reg [255:0] state;  
    reg [31:0] temp_counter;  
    reg [5:0] step;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= 256'b0;  
            output_data <= 64'b0;  
            ready <= 1'b0;  
            step <= 6'b0;  
        end else if (start) begin  
            if (step == 6'b0) begin  
                state <= key;  
                state[63:0] <= nonce;  
                temp_counter <= counter;  
                step <= step + 1;  
                ready <= 1'b0;  
            end else if (step < 6'd10) begin  
                // Simplified processing of ChaCha20 state 
                state <= {state[255:64] + 1'b1, state[63:0]};  
                step <= step + 1;  
            end else begin  
                output_data <= state[63:0] ^ temp_counter;  
                ready <= 1'b1;  
                step <= 6'b0;  
            end  
        end  
    end  
endmodule