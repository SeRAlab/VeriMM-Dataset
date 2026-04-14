module crystal_oscillator(
    input clk,          // Clock input
    input rst_n,       // Active low reset
    output reg out     // Oscillator output
);
    reg [1:0] count;   // 2-bit counter for frequency division

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            out <= 0;   // Reset output
            count <= 0; // Reset counter
        end else begin
            count <= count + 1;
            if (count == 2'b11) begin
                out <= ~out; // Toggle output every 4 clock cycles
                count <= 0;  // Reset counter
            end
        end
    end
endmodule