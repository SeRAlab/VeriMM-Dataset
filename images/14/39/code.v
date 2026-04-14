module qam_modulator(
    input [3:0] data_in,
    output reg [1:0] I,
    output reg [1:0] Q
);
    always @(*) begin
        case(data_in)
            4'b0000: {I, Q} = 4'b0000;
            4'b0001: {I, Q} = 4'b0001;
            4'b0010: {I, Q} = 4'b0100;
            4'b0011: {I, Q} = 4'b0101;
            4'b0100: {I, Q} = 4'b1000;
            4'b0101: {I, Q} = 4'b1001;
            4'b0110: {I, Q} = 4'b1100;
            4'b0111: {I, Q} = 4'b1101;
            4'b1000: {I, Q} = 4'b0010;
            4'b1001: {I, Q} = 4'b0011;
            4'b1010: {I, Q} = 4'b0110;
            4'b1011: {I, Q} = 4'b0111;
            4'b1100: {I, Q} = 4'b1010;
            4'b1101: {I, Q} = 4'b1011;
            4'b1110: {I, Q} = 4'b1110;
            4'b1111: {I, Q} = 4'b1111;
            default: {I, Q} = 4'b0000;
        endcase
    end
endmodule