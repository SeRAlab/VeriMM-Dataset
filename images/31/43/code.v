module turbo_encoder (
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
            shift_reg <= {shift_reg[0], data_in};
            data_out <= {data_in ^ shift_reg[1], data_in}; // Simple convolutional encoding
        end
    end
endmodule