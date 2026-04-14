module binary_counter (
    input wire Clk,
    input wire Rst,
    output reg [3:0] Q
    );

always @(posedge Clk) begin
    if (Rst)
        Q <= 4'b0000;
    else
        Q <= Q + 1;
end

endmodule