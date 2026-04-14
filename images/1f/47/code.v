module pll_4x (
    input wire clk_in,
    input wire reset,
    output reg clk_out
);
    reg [1:0] phase_counter;
    
    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            phase_counter <= 2'b00;
            clk_out <= 0;
        end else begin
            phase_counter <= phase_counter + 1;
            if (phase_counter == 2'b11) begin
                clk_out <= ~clk_out; // Toggle output clock every 4 input clocks
            end
        end
    end
endmodule