module qam_modulator (
    input [1:0] I,
    input [1:0] Q,
    output reg [3:0] symbol
);
    always @(*) begin
        case ({I, Q})
            4'b0000: symbol = 4'b0000; // 00
            4'b0001: symbol = 4'b0001; // 01
            4'b0010: symbol = 4'b0010; // 10
            4'b0011: symbol = 4'b0011; // 11
            default: symbol = 4'bxxxx;  // undefined
        endcase
    end
endmodule