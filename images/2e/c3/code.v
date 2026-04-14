module shift_register (
    input clk,
    input rst,
    input d,
    output reg [1:0] q
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= 2'b00;
        end else begin
            q <= {q[0], d}; // Shift left and input d
        end
    end
endmodule