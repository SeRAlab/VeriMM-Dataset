module d_flip_flop (
    input wire clk,
    input wire rst,
    input wire en,
    input wire d,
    output reg q
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= 0; // Asynchronous reset
        end else if (en) begin
            q <= d; // Capture D on rising edge of CLK when EN is high
        end
    end
endmodule