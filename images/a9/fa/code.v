module top_module(
    input clk,
    input ce,
    input [1:0] LoadPC,
    input GotInterrupt,
    input [7:0] DIN,
    input [7:0] T,
    output reg [15:0] PC,
    output JumpNoOverflow
);reg [15:0] NewPC; 
    assign JumpNoOverflow = ((PC[8] ^ NewPC[8]) == 0) & LoadPC[0] & LoadPC[1]; 
    
    always @(*) begin 
        case (LoadPC) 
            2'b00, 2'b01: NewPC = PC + {15'b0, (LoadPC[0] & ~GotInterrupt)}; 
            2'b10: NewPC = {DIN, T}; 
            2'b11: NewPC = PC + {{8{T[7]}}, T}; 
            default: NewPC = PC; // Added default case to prevent latches
        endcase 
    end 
    
    always @(posedge clk) begin
        if (ce) 
            PC <= NewPC; 
    end 
endmodule