module crystal_oscillator #(parameter DIVIDER = 2) (
    input wire clk,
    output reg out
);
    reg [31:0] counter;

    always @(posedge clk) begin
        counter <= counter + 1;
        if (counter >= DIVIDER - 1) begin
            out <= ~out;
            counter <= 0;
        end
    end
endmodule