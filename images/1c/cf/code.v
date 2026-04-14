module convolutional_encoder (
    input clk,
    input rst,
    input start,
    input [0:0] data_in,
    output reg [1:0] data_out,
    output reg done
);
    reg [2:0] shift_reg;
    reg [2:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 3'b000;
            count <= 3'b000;
            data_out <= 2'b00;
            done <= 0;
        end else if (start) begin
            if (count < 5) begin // assuming we want to encode 5 bits
                shift_reg <= {shift_reg[1:0], data_in};
                data_out <= {shift_reg[2] ^ shift_reg[1] ^ shift_reg[0], shift_reg[2] ^ shift_reg[0]};
                count <= count + 1;
            end else begin
                done <= 1;
            end
        end
    end
endmodule