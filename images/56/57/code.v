module top_module(dec_in, dec_out, enable);input [2:0] dec_in;
input enable;
output [7:0] dec_out;

reg [7:0] dec_out;

always @(enable or dec_in)
    begin
        dec_out = 0;
        if(enable) begin 
            case (dec_in)
                0: dec_out = 1;
                1: dec_out = 2;
                2: dec_out = 4;
                3: dec_out = 8;
                4: dec_out = 16;
                5: dec_out = 32;
                6: dec_out = 64;
                7: dec_out = 128;
            endcase
        end
    end
endmodule