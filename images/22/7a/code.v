module convolutional_encoder(
    input clk,
    input reset,
    input data_in,
    output reg [1:0] data_out
);
    reg [1:0] memory;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            memory <= 2'b00;
            data_out <= 2'b00;
        end else begin
            data_out[0] <= data_in ^ memory[0] ^ memory[1];
            data_out[1] <= memory[0] ^ memory[1];
            memory <= {data_in, memory[0]};
        end
    end
endmodule