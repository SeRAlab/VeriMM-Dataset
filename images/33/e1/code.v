module convolutional_encoder (
    input wire clk,
    input wire reset,
    input wire data_in,
    output reg [1:0] data_out
);
    reg [2:0] shift_register;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_register <= 3'b000;
            data_out <= 2'b00;
        end else begin
            shift_register <= {data_in, shift_register[2:1]};
            data_out <= {shift_register[2] ^ shift_register[1] ^ shift_register[0], shift_register[2] ^ shift_register[0]};
        end
    end
endmodule