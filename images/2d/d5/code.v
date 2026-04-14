module nonce_incrementer(  
    input wire clk,  
    input wire rst,  
    input wire [31:0] nonce_in,  
    output reg [31:0] nonce_out  
);  

    always @(posedge clk or posedge rst) begin  
        if (rst)  
            nonce_out <= 32'b0;  
        else  
            nonce_out <= nonce_in + 1;  
    end  
endmodule