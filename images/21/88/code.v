module des_simple_encryption(
    input [7:0] data_in,
    input [1:0] key,
    output reg [7:0] data_out
);
    
    always @(data_in or key) begin
        // Simple substitution based on key
        case (key)
            2'b00: data_out = {data_in[3:0], data_in[7:4]}; // Swap halves
            2'b01: data_out = {data_in[6:0], data_in[7]}; // Rotate left
            2'b10: data_out = {data_in[7:1], data_in[0]}; // Rotate right
            2'b11: data_out = ~data_in; // Bitwise NOT
            default: data_out = data_in; // No change
        endcase
    end
endmodule