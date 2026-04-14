module fractional_n_pll (
    input wire clk,
    input wire reset,
    input wire [7:0] fractional_divisor,
    output reg pll_output
);
    reg [7:0] counter;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 8'b0;
            pll_output <= 1'b0;
        end else begin
            counter <= counter + 1;
            if (counter >= fractional_divisor) begin
                pll_output <= ~pll_output; // Toggle output
                counter <= 8'b0; // Reset counter
            end
        end
    end
endmodule