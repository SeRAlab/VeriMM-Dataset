module convolutional_encoder(
    input clk,
    input reset,
    input start,
    input [0:0] data_in,
    output reg [1:0] data_out,
    output reg done
);
    reg [6:0] state;
    wire [6:0] next_state;
    wire [1:0] output_bits;

    assign output_bits = { 
        (data_in ^ state[0] ^ state[1] ^ state[2] ^ state[3] ^ state[4] ^ state[6]),  // G1
        (data_in ^ state[1] ^ state[2] ^ state[4] ^ state[5] ^ state[6])           // G2
    };

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 7'b0;
            data_out <= 2'b0;
            done <= 0;
        end
        else if (start) begin
            state <= {state[5:0], data_in};
            data_out <= output_bits;
            done <= 1;  // Indicate that the output has been produced
        end
    end
endmodule