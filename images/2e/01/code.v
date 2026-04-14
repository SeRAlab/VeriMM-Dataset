module dff_4bit (
    input [3:0] D,
    input CLK,
    input RESET,
    input EN,
    output reg [3:0] Q
);

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        Q <= 4'b0000;
    end else if (EN) begin
        Q <= D;
    end
end

endmodule