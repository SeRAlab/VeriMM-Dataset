module chacha20_round (  
    input wire [31:0] key,  
    input wire [31:0] counter,  
    output reg [31:0] output_val  
);  
    always @(key, counter) begin  
        output_val = key ^ counter; // Simple XOR operation  
    end  
endmodule