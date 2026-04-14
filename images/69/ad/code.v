module top_module(
    input [3:0] D0,
    input [3:0] D1,
    input [3:0] D2,
    input [3:0] D3,
    input [1:0] SHIFT,
    input LOAD,
    input CLK,
    output [3:0] OUT
);reg [3:0] shift_reg;
    
    always @(posedge CLK) begin
        if (LOAD) begin
            shift_reg <= {D3, D2, D1, D0}; // Assuming this is intended to load in a 4-bit value
        end else begin
            case (SHIFT)
                2'b00: shift_reg <= shift_reg; // No shift
                2'b01: shift_reg <= {shift_reg[2:0], 1'b0}; // Shift right
                2'b10: shift_reg <= {1'b0, shift_reg[3:1]}; // Shift left
                2'b11: shift_reg <= {1'b0, 1'b0, shift_reg[3:2]}; // Shift left more than one
            endcase
        end
    end
    
    assign OUT = shift_reg;
    
endmodule