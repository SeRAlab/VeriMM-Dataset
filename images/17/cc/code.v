module convolutional_encoder(
    input clk,
    input reset,
    input data_in,
    output reg [1:0] data_out
);
    reg prev_input;
    reg [1:0] memory; // memory to hold the previous inputs

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            prev_input <= 0;
            memory <= 0;
            data_out <= 2'b00;
        end else begin
            data_out[0] <= data_in ^ prev_input; // first output bit
            data_out[1] <= data_in ^ memory[0];  // second output bit
            memory <= {prev_input, data_in};      // update memory
            prev_input <= data_in;                // update previous input
        end
    end
endmodule