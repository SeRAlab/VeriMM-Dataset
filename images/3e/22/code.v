module chacha20_core (  
    input wire clk,  
    input wire rst,  
    input wire [31:0] key,  
    output reg [31:0] output_stream  
);  
    reg [31:0] state;  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= key;  
        end else begin  
            // Simple LFSR for demonstration purposes  
            state <= {state[30:0], state[31] ^ state[21] ^ state[1] ^ state[0]};  
        end  
    end  
    always @(posedge clk) begin  
        output_stream <= state;  
    end  
endmodule