module convolutional_encoder (
    input wire clk,
    input wire reset,
    input wire data_in,
    output reg [1:0] encoded_out
);
    reg [2:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 3'b000;
            encoded_out <= 2'b00;
        end else begin
            shift_reg <= {shift_reg[1:0], data_in}; // Shift in new data
            encoded_out[0] <= shift_reg[2] ^ shift_reg[1] ^ shift_reg[0]; // G1
            encoded_out[1] <= shift_reg[2] ^ shift_reg[0]; // G2
        end
    end
endmodule