module d_ff_8bit(
    input wire CLK,
    input wire RST,
    input wire [7:0] D,
    output reg [7:0] Q
    );

always @(posedge CLK or posedge RST) begin
    if (RST) 
        Q <= 8'b0;
    else 
        Q <= D;
end

endmodule