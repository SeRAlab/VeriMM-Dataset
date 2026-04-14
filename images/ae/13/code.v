module priority_encoder(
    input wire [3:0] one_hot_in,
    output reg [1:0] bin_out
);

always @(*) begin
    casez (one_hot_in)
        4'b0001: bin_out = 2'b00;
        4'b0010: bin_out = 2'b01;
        4'b0100: bin_out = 2'b10;
        4'b1000: bin_out = 2'b11;
        default: bin_out = 2'b00; // Default case to handle invalid inputs
    endcase
end

endmodule