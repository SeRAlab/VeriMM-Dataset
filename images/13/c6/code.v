module simplified_md5 (  
    input clk,  
    input rst,  
    input [511:0] message,  
    output reg [127:0] hash  
);  

    reg [127:0] state;  
    integer i;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            hash <= 128'h0;  
            state <= 128'h0;  
        end else begin  
            state <= message[127:0] ^ message[255:128]; // Example operation  
            for (i = 0; i < 16; i = i + 1) begin  
                state <= {state[119:0], state[127:120]} + message[i*32 +: 32]; // Rotate and add  
            end  
            hash <= state;  
        end  
    end  
endmodule