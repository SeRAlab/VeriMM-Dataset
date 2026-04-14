module shift_register_4bit (
    input wire [3:0] D,
    input wire Clk,
    input wire Shift,
    output reg [3:0] Q
    );

always @(posedge Clk) begin
    if (Shift)
        Q <= {1'b0, Q[3:1]};
    else
        Q <= D;
end

endmodule