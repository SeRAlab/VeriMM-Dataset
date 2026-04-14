module bin_counter_4bit_up_down (CLK, RST, MODE, Q);
input CLK, RST, MODE;
output reg [3:0] Q;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Q <= 4'b0000;
    end else if (MODE) begin
        Q <= Q + 1;
    end else begin
        Q <= Q - 1;
    end
end

endmodule