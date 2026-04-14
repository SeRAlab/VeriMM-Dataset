module fractional_n_pll (
    input wire clk_ref,
    input wire [7:0] fractional_n,
    output reg clk_out
);
    reg [15:0] counter;
    reg [15:0] div_value;

    always @(posedge clk_ref) begin
        div_value <= {fractional_n, 8'b0}; // Assign the division value from fractional_n
        counter <= counter + 1;
        if (counter >= div_value) begin
            clk_out <= ~clk_out; // Toggle output clock when counter reaches division value
            counter <= 0; // Reset counter
        end
    end
endmodule