module top_module(data1, data2 ,clk, ctrl, oCarry,oZero, out);input [31:0] data1;
input [31:0] data2;
input [2:0] ctrl;
input clk;
output reg oCarry;
output reg oZero;
output reg [31:0] out;

always@ (*)
    begin 
        case(ctrl)
            3'b010: {oCarry ,out} = data1+data2;
            3'b110: begin {oCarry, out} = data1-data2;
                                              
                    if (out == 32'b0000_0000_0000_0000_0000_0000_0000_0000)
                            oZero = 1;
                        else 
                            oZero = 0;
                    end
      
            3'b000: out = data1&data2;
            3'b001: out = data1|data2;
            3'b111: out = data1^data2;
            default: 
                begin
                    out  = data1;
                    oZero = 0;
                    oCarry = 0;
                end            
        endcase
    end
endmodule