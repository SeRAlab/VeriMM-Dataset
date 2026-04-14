module invert_msb(
    input [3:0] i_binary,
    output reg [3:0] o_inverted
    );

    always @(*) begin
        o_inverted = {~i_binary[3], i_binary[2:0]};
    end

endmodule