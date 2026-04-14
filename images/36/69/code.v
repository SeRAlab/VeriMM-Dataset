module convolutional_encoder (
    input clk,
    input rst,
    input data_in,
    output reg [1:0] data_out
);
    reg [2:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 3'b000; // Reset shift register
            data_out <= 2'b00;   // Reset output
        end else begin
            shift_reg <= {data_in, shift_reg[2:1]}; // Shift in new data
            // Generate output using the generator polynomials
            data_out[0] <= shift_reg[2] ^ shift_reg[1] ^ shift_reg[0]; // G1 = 111
            data_out[1] <= shift_reg[2] ^ shift_reg[0];                 // G2 = 101
        end
    end
endmodule