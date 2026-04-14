module up_down_counter_3bit(
    input wire CLK,
    input wire RST,
    input wire UP,
    output reg [2:0] Q
    );

always @(posedge CLK) begin
    if (RST)
        Q <= 3'b0;
    else if (UP)
        Q <= Q + 1;
    else
        Q <= Q - 1;
end

endmodule