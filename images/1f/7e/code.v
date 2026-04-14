module aes_round(
    input [3:0] data_in,
    input [3:0] round_key,
    input clk,
    input rst,
    output reg [3:0] data_out
);
    // S-box transformation (example)
    function [3:0] sbox;
        input [3:0] in;
        begin
            case(in)
                4'b0000: sbox = 4'b1110;
                4'b0001: sbox = 4'b0100;
                4'b0010: sbox = 4'b1101;
                4'b0011: sbox = 4'b0001;
                4'b0100: sbox = 4'b1011;
                4'b0101: sbox = 4'b1000;
                4'b0110: sbox = 4'b0011;
                4'b0111: sbox = 4'b1010;
                4'b1000: sbox = 4'b0110;
                4'b1001: sbox = 4'b1111;
                4'b1010: sbox = 4'b0000;
                4'b1011: sbox = 4'b1100;
                4'b1100: sbox = 4'b0010;
                4'b1101: sbox = 4'b0101;
                4'b1110: sbox = 4'b1001;
                4'b1111: sbox = 4'b0111;
                default: sbox = 4'b0000;
            endcase
        end
    endfunction

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 4'b0000;
        end else begin
            data_out <= sbox(data_in) ^ round_key;
        end
    end
endmodule