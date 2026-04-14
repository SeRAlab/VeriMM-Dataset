module turbo_decoder(  
    input wire clk,  
    input wire rst,  
    input wire [3:0] encoded_input,  
    output reg [3:0] decoded_output  
);  
    reg [3:0] intermediate;  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            decoded_output <= 4'b0000;  
            intermediate <= 4'b0000;  
        end else begin  
            // Simple decoding logic (for demonstration purposes)  
            intermediate <= encoded_input ^ 4'b1010;  
            decoded_output <= intermediate;  
        end  
    end  
endmodule