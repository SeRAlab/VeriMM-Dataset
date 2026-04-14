module top_module(
    input  [3:0] D,
    input  S0,
    input  S1,
    output Y
);reg [1:0] sel;
    
    always @ (S0 or S1) begin
        case ({S1, S0})
            2'b00: sel = 2'b00;
            2'b01: sel = 2'b01;
            2'b10: sel = 2'b10;
            2'b11: sel = 2'b11;
        endcase
    end
    
    assign Y = D[sel];
    
endmodule