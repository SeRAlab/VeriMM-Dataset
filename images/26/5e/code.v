module des_encrypt(input [3:0] data_in, input [1:0] key, output reg [3:0] data_out);
    always @(data_in or key) begin
        case(key)
            2'b00: data_out = {data_in[2:0], data_in[3]}; // Rotate left
            2'b01: data_out = {data_in[1:0], data_in[3:2]}; // Swap halves
            2'b10: data_out = {data_in[3:2], data_in[1:0]}; // Swap and rotate
            2'b11: data_out = ~data_in; // Bitwise NOT
            default: data_out = data_in; // No operation
        endcase
    end
endmodule