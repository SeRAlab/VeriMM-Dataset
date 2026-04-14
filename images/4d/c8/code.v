module bin_to_onehot(
    input [2:0] bin,
    output reg [7:0] onehot
);

always @(*) begin
    case (bin)
        3'd0: onehot = 8'b00000001;
        3'd1: onehot = 8'b00000010;
        3'd2: onehot = 8'b00000100;
        3'd3: onehot = 8'b00001000;
        3'd4: onehot = 8'b00010000;
        3'd5: onehot = 8'b00100000;
        3'd6: onehot = 8'b01000000;
        3'd7: onehot = 8'b10000000;
        default: onehot = 8'b00000000;
    endcase
end

endmodule