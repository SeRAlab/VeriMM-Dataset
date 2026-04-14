module priority_encoder (
    input [4:0] in,
    output reg [2:0] pos);

    always @(*) begin
        casez (in)
            5'b????1: pos = 3'd0;
            5'b???10: pos = 3'd1;
            5'b??100: pos = 3'd2;
            5'b?1000: pos = 3'd3;
            5'b10000: pos = 3'd4;
            default: pos = 3'd0;
        endcase
    end
endmodule