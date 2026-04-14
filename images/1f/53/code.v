module conv_encoder (
    input clk,
    input rst,
    input din,
    output reg [1:0] dout
);
    reg [2:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 3'b000;
            dout <= 2'b00;
        end else begin
            shift_reg <= {din, shift_reg[2:1]};
            dout[0] <= shift_reg[2] ^ shift_reg[1] ^ shift_reg[0]; // g1 = 111
            dout[1] <= shift_reg[2] ^ shift_reg[0]; // g2 = 101
        end
    end
endmodule