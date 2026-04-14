module crystal_oscillator (
    input wire clk,
    input wire enable,
    output reg out_clk
);
    reg [2:0] counter;

    always @(posedge clk) begin
        if (enable) begin
            if (counter == 4) begin
                out_clk <= ~out_clk; // Toggle the output clock
                counter <= 0; // Reset counter
            end else begin
                counter <= counter + 1; // Increment counter
            end
        end
    end
endmodule