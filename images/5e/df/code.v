module top_module(signal, A, B, C, selected);input [1:0] signal;
    input [31:0] A, B, C;
    output reg [31:0] selected;
    
    always @(signal or A or B or C) begin
        case(signal)
            2'b00: selected = A;
            2'b01: selected = B;
            2'b10: selected = C;
        endcase
    end
endmodule