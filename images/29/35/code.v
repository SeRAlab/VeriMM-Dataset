module turbo_encoder (
    input wire clk,
    input wire rst,
    input wire [3:0] data_in,
    input wire valid,
    output reg [5:0] encoded_out,
    output reg ready
);
    reg [3:0] interleaved_data;
    reg [5:0] encoder1_out;
    reg [5:0] encoder2_out;

    // Simple convolutional encoder (parity bits generation)
    function [5:0] convolutional_encoder;
        input [3:0] data;
        begin
            convolutional_encoder[0] = data[0] ^ data[1]; // Parity 1
            convolutional_encoder[1] = data[1] ^ data[2]; // Parity 2
            convolutional_encoder[2] = data[2] ^ data[3]; // Parity 3
            convolutional_encoder[3] = data[0];           // Data bit 1
            convolutional_encoder[4] = data[1];           // Data bit 2
            convolutional_encoder[5] = data[2];           // Data bit 3
        end
    endfunction

    // Simple interleaver
    always @(*) begin
        interleaved_data = {data_in[3], data_in[1], data_in[0], data_in[2]};
    end

    // State machine to encode data
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            encoded_out <= 0;
            ready <= 0;
        end else if (valid) begin
            encoder1_out <= convolutional_encoder(data_in);
            encoder2_out <= convolutional_encoder(interleaved_data);
            encoded_out <= {encoder1_out, encoder2_out[2:0]}; // Taking only part of encoder2 for output
            ready <= 1;
        end else begin
            ready <= 0;
        end
    end
endmodule