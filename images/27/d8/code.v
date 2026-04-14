module convolutional_encoder (
    input wire clk,
    input wire reset,
    input wire [1:0] data_in,
    output reg [3:0] data_out
);
    reg memory;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            memory <= 1'b0;
            data_out <= 4'b0000;
        end else begin
            data_out[3] <= data_in[0] ^ memory; // first output from G1
            data_out[2] <= data_in[1] ^ memory; // second output from G2
            data_out[1] <= memory; // previous memory state
            data_out[0] <= data_in[0]; // current input (first bit)
            memory <= data_in[0]; // update memory with current input
        end
    end
endmodule