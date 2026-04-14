module top_module(input wire[3:0] in_val, input wire[3:0] const_val, output reg[3:0] out_val);always @* begin
        out_val = ((in_val + const_val) > 4'b0111) ? 4'b0111 : (in_val + const_val);
    end
    
endmodule