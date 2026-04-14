module des_encrypt(  
    input clk,  
    input [63:0] data_in,  
    input [63:0] key_in,  
    output reg [63:0] data_out  
);  
    reg [63:0] temp_data;  
    reg [63:0] temp_key;  

    always @(posedge clk) begin  
        temp_key <= {key_in[31:0], key_in[63:32]}; // Simple key permutation  
        temp_data <= data_in ^ temp_key; // XOR with key  
        data_out <= {temp_data[15:0], temp_data[31:16], temp_data[47:32], temp_data[63:48]}; // Simple permutation  
    end  
endmodule