module divide_by_2 (
    input wire clk,
    input wire D,
    output reg Q
);
    always @(posedge clk) begin
        Q <= D ^ Q; // Divide by 2 using XOR with current state
    end
endmodule