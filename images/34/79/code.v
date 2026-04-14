module QAM_Modulator (
    input [3:0] I,
    input [3:0] Q,
    output reg [1:0] symbol
);
    always @(*) begin
        case ({I[3:2], Q[3:2]}) // Use only the two most significant bits of I and Q
            4'b00: symbol = 2'b00; // (0, 0)
            4'b01: symbol = 2'b01; // (0, 1)
            4'b10: symbol = 2'b10; // (1, 0)
            4'b11: symbol = 2'b11; // (1, 1)
            default: symbol = 2'b00; // Default case
        endcase
    end
endmodule