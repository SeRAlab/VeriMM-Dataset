module up_down_counter_4bit (CLK, RESET, UP_DOWN, EN, Q);
input CLK;
input RESET;
input UP_DOWN;
input EN;
output reg [3:0] Q;

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        Q <= 4'b0000;
    end
    else if (EN) begin
        if (UP_DOWN) begin
            Q <= Q + 1;
        end
        else begin
            Q <= Q - 1;
        end
    end
end

endmodule