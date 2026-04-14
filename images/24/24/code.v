module shift_register (
    input wire clk,
    input wire rst_n,
    input wire [1:0] d,
    output reg [1:0] q
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            q <= 2'b00; // Asynchronous reset
        end else begin
            q <= {q[0], d[0]}; // Shift left and input d[0] into LSB
        end
    end
endmodule