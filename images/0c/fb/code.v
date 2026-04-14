module turbo_encoder (
    input [3:0] data_in,
    output reg [5:0] data_out
);
    always @(*) begin
        // Simple convolutional encoding logic
        data_out[0] = data_in[0]; // Input bit 0
        data_out[1] = data_in[1]; // Input bit 1
        data_out[2] = data_in[2]; // Input bit 2
        data_out[3] = data_in[3]; // Input bit 3
        data_out[4] = data_in[0] ^ data_in[1]; // Parity bit 1
        data_out[5] = data_in[2] ^ data_in[3]; // Parity bit 2
    end
endmodule