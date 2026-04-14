module d_ff(
    input wire clk,
    input wire rst,
    input wire D,
    output reg Q
    );

always @(posedge clk or posedge rst) begin
    if (rst) begin
        Q <= 0;
    end else begin
        Q <= D;
    end
end

endmodule