module counter_4bit (
    input wire clk,
    input wire reset,
    input wire En,
    output reg [3:0] Q
    );

always @(posedge clk or posedge reset) begin
    if (reset)
        Q <= 4'b0000;
    else if (En)
        Q <= Q + 1;
end

endmodule