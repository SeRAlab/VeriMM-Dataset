module qam_encoder (
    input  [1:0] I,
    input  [1:0] Q,
    output reg [3:0] QAM_out
);
    always @(*) begin
        case ({I, Q})
            4'b0000: QAM_out = 4'b0000; // 00
            4'b0001: QAM_out = 4'b0001; // 01
            4'b0010: QAM_out = 4'b0010; // 10
            4'b0011: QAM_out = 4'b0011; // 11
            default: QAM_out = 4'bxxxx; // Invalid case
        endcase
    end
endmodule