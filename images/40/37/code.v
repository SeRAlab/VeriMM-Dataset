module dual_modulus_prescaler (
    input wire clk_in,          // Input clock
    input wire ctrl,           // Control signal (0 or 1)
    output reg clk_out         // Output divided clock
);
    reg [1:0] counter;

    always @(posedge clk_in) begin
        if (ctrl == 0) begin
            // Divide by 2
            counter <= counter + 1;
            if (counter == 2) begin
                clk_out <= ~clk_out;
                counter <= 0;
            end
        end else begin
            // Divide by 3
            counter <= counter + 1;
            if (counter == 3) begin
                clk_out <= ~clk_out;
                counter <= 0;
            end
        end
    end

endmodule