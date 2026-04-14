module top_module(
    input [7:0] v,
    input en_in_n,
    output reg [2:0] y,
    output reg en_out,
    output reg gs
    );always @(v or en_in_n) begin
        case ({en_in_n, v})
            9'b1_xxxx_xxxx: {y, gs, en_out} = 5'b1_1111;
            9'b0_1111_1111: {y, gs, en_out} = 5'b1_1110;
            9'b0_xxxx_xxx0: {y, gs, en_out} = 5'b0_0001;
            9'b0_xxxx_xx01: {y, gs, en_out} = 5'b0_0101;
            9'b0_xxxx_x011: {y, gs, en_out} = 5'b0_1001;
            9'b0_xxxx_0111: {y, gs, en_out} = 5'b0_1101;
            9'b0_xxx0_1111: {y, gs, en_out} = 5'b1_0001;
            9'b0_xx01_1111: {y, gs, en_out} = 5'b1_0101;
            9'b0_x011_1111: {y, gs, en_out} = 5'b1_1001;
            9'b0_0111_1111: {y, gs, en_out} = 5'b1_1101;
        endcase
    end
endmodule