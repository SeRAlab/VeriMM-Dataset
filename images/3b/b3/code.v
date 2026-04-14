module shift_register (
    input clk,
    input rst,
    input shift_in,
    input direction, // 1 for left shift, 0 for right shift
    output reg [15:0] shift_reg
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 16'b0;
        end else begin
            if (direction) begin
                shift_reg <= {shift_reg[14:0], shift_in}; // Left shift
            end else begin
                shift_reg <= {shift_in, shift_reg[15:1]}; // Right shift
            end
        end
    end
endmodule