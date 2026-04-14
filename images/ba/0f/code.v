module up_down_counter(CLK, RST, EN, CTRL, Q);
input CLK, RST, EN, CTRL;
output reg [7:0] Q;

always @(posedge CLK) begin
    if (RST)
        Q <= 8'b00000000;
    else if (EN) begin
        if (CTRL)
            Q <= Q + 1;  // Increment
        else
            Q <= Q - 1;  // Decrement
    end
end

endmodule