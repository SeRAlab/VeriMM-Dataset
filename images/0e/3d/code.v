module convolutional_encoder (
    input clk,
    input rst,
    input data_in,
    output reg data_out1,
    output reg data_out2
);
    reg [1:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 2'b00;
            data_out1 <= 0;
            data_out2 <= 0;
        end else begin
            shift_reg <= {data_in, shift_reg[1]};
            data_out1 <= shift_reg[0] ^ shift_reg[1] ^ data_in;  // g1 = 1 + x + x^2
            data_out2 <= shift_reg[1] ^ data_in;                 // g2 = 1 + x^2
        end
    end
endmodule