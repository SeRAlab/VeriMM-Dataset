module shift_register (
    input clk,
    input reset,
    input d,
    output reg [1:0] q
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 2'b00;
        end else begin
            q <= {q[0], d}; // Shift left and insert d into LSB
        end
    end
endmodule