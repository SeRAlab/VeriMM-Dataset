module T_flip_flop (
    input wire T,
    input wire clk,
    input wire rst,
    output reg Q
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Q <= 0; // Asynchronous reset
        end else if (T) begin
            Q <= ~Q; // Toggle output
        end
    end
endmodule