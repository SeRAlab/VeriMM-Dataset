module convolutional_encoder (
    input clk,
    input reset,
    input data_in,
    output reg [1:0] data_out
);
    reg [6:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 7'b0;
            data_out <= 2'b00;
        end else begin
            shift_reg <= {data_in, shift_reg[6:1]};
            data_out[0] <= shift_reg[6] ^ shift_reg[5] ^ shift_reg[4]; // G1 = 111
            data_out[1] <= shift_reg[6] ^ shift_reg[4];                 // G2 = 101
        end
    end
endmodule