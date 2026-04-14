module conv_encoder (
    input clk,
    input reset,
    input [1:0] data_in,
    output reg [2:0] data_out
);
    reg [1:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 2'b00;
            data_out <= 3'b000;
        end else begin
            shift_reg <= {data_in, shift_reg[1]};
            data_out <= {shift_reg[1] ^ data_in[1], shift_reg[0] ^ data_in[0], data_in[1]};
        end
    end
endmodule