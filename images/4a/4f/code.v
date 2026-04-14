module verified_shift_reg_4bit(
    input clk,
    input rst,
    input load,
    input shift,
    input [3:0] data_in,
    
    output reg [3:0] q
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 4'b0000;
        else if (load)
            q <= data_in;
        else if (shift)
            q <= {q[2:0], 1'b0}; // Shift left
        else
            q <= {1'b0, q[3:1]}; // Shift right
    end
endmodule