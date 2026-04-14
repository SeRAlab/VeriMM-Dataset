module turbo_encoder (
    input wire [3:0] data_in,
    output wire [7:0] encoded_out
);
    // Simple convolutional coding: (n=3, k=1)
    wire [3:0] conv1_out;
    wire [3:0] conv2_out;

    // First convolutional encoder
    assign conv1_out[0] = data_in[0]; // 0
    assign conv1_out[1] = data_in[0] ^ data_in[1]; // 1
    assign conv1_out[2] = data_in[1] ^ data_in[2]; // 2
    assign conv1_out[3] = data_in[2] ^ data_in[3]; // 3

    // Second identical convolutional encoder
    assign conv2_out[0] = data_in[0]; // 0
    assign conv2_out[1] = data_in[0] ^ data_in[1]; // 1
    assign conv2_out[2] = data_in[1] ^ data_in[2]; // 2
    assign conv2_out[3] = data_in[2] ^ data_in[3]; // 3

    // Combine outputs
    assign encoded_out = {conv1_out, conv2_out};
endmodule