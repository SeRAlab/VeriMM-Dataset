module counter_4bit(
    input wire CLK,
    input wire RST,
    output reg [3:0] Q
    );

always @(posedge CLK) begin
    if (RST)
        Q <= 4'b0;
    else
        Q <= Q + 1;
end

endmodule