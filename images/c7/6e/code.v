module up_counter(
    input CLK,
    input RESET_B,
    output reg [3:0] Q
);

always @(posedge CLK) begin
    if(RESET_B == 0) begin
        Q <= 4'b0000;
    end else begin
        Q <= Q + 1;
    end
end

endmodule