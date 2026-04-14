module mux_3to1 (
    input [2:0] data_in, // 3 inputs
    input [1:0] sel,     // 2-bit select signal
    output reg out       // output
);
    always @(*) begin
        case(sel)
            2'b00: out = data_in[0]; // Select input 0
            2'b01: out = data_in[1]; // Select input 1
            2'b10: out = data_in[2]; // Select input 2
            default: out = 1'b0;      // Default case
        endcase
    end
endmodule