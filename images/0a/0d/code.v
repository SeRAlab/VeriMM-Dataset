module shift_register (
    input clk,
    input reset,
    input new_bit,
    output reg [15:0] shift_reg
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 16'b0;
        end else begin
            shift_reg <= {shift_reg[14:0], new_bit}; // Shift left and insert new_bit
        end
    end
endmodule