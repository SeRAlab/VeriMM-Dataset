module des_round (
    input wire [63:0] data_in,
    input wire [55:0] key,
    output wire [63:0] data_out,
    input wire clk,
    input wire rst
);
    wire [47:0] expanded_key;
    wire [31:0] left, right, new_left, new_right;
    
    // Key expansion (simplified in this example)
    assign expanded_key = {key[55:0], 16'b0}; // Dummy expansion for illustration
    
    // Initial split
    assign left = data_in[63:32];
    assign right = data_in[31:0];
    
    // Feistel function (simplified)
    assign new_right = left ^ (right & expanded_key[47:0]);
    assign new_left = right;
    
    // Output formation
    assign data_out = {new_right, new_left};
    
endmodule