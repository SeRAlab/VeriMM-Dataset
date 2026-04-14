module top_module(enc_in, enc_out, enable);input [7:0] enc_in;
input enable;
output [2:0] enc_out;

reg [2:0] enc_out;

always @(enable or enc_in)
    begin
        enc_out = 0;
        if(enable) begin 
            case (enc_in)
                1: enc_out = 0;
                2: enc_out = 1;
                4: enc_out = 2;
                8: enc_out = 3;
                16: enc_out = 4;
                32: enc_out = 5;
                64: enc_out = 6;
                128: enc_out = 7;
            endcase
        end
    end
endmodule