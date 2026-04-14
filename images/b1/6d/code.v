module top_module(out, inA, inB, inC, sel);input inA, inB, inC;
    input [1:0] sel;
    output reg out;
    
    always@(inA, inB, inC, sel) begin
        case(sel)
            2'b00: out <= inA;
            2'b01: out <= inB;
            2'b10: out <= inC;
        endcase
    end
endmodule