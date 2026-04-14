module d_flip_flop (
    input clk,
    input rst_n,
    input en,
    input d,
    output reg q
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            q <= 1'b0; // Asynchronous reset
        end else if (en) begin
            q <= d; // Capture D on the rising edge of CLK when EN is high
        end
    end
endmodule