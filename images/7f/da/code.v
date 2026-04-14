module up_down_counter_3bit(
    input wire CLK,
    input wire RST,
    input wire UP,
    output reg [2:0] Q
    );

always @(posedge CLK) begin
    if (RST) begin
        Q <= 3'b000;
    end else if (UP) begin
        Q <= Q + 1;
    end else begin
        Q <= Q - 1;
    end
end

endmodule