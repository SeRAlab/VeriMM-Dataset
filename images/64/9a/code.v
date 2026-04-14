module top_module(out, inA, inB, sel);output reg [4:0] out;
    
    input [4:0] inA;
    input [4:0] inB;
    input sel;

    always @(inA, inB, sel) begin
        if (sel == 0) begin
            out <= inA;
        end
        else
            out <= inB;        
    end
    
endmodule