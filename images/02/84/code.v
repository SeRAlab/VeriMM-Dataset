module convolutional_encoder (
    input wire clk,
    input wire reset,
    input wire valid_in,
    input wire data_in,
    output reg [1:0] encoded_out,
    output reg valid_out
);
    reg [2:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 3'b000;
            valid_out <= 0;
            encoded_out <= 2'b00;
        end else begin
            if (valid_in) begin
                shift_reg <= {data_in, shift_reg[2:1]};
                encoded_out <= {shift_reg[2] ^ shift_reg[1] ^ shift_reg[0], shift_reg[1] ^ shift_reg[0]};
                valid_out <= 1;
            end else begin
                valid_out <= 0;
            end
        end
    end
endmodule