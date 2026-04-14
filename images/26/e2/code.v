module convolutional_encoder (
    input clk,
    input rst,
    input data_in,
    output reg [1:0] data_out
);
    reg [1:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 2'b00;
            data_out <= 2'b00;
        end else begin
            shift_reg <= {shift_reg[0], data_in}; // Shift in the new data
            // Convolutional encoding using the generator polynomials
            data_out[0] <= shift_reg[1] ^ shift_reg[0] ^ data_in; // G1
            data_out[1] <= shift_reg[1] ^ data_in;                 // G2
        end
    end
endmodule