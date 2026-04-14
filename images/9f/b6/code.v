module top_module(
    input reset,
    output reg clk
);// Define the clock period
    localparam PERIOD = 10;

    // Define the clock half period
    localparam HALF_PERIOD = PERIOD / 2;

    // Define the clock counter
    reg [31:0] counter = 0;

    // Generate the clock signal
    always @(posedge reset or negedge clk) begin
        if (reset) begin
            // Reset the clock counter and output
            counter <= 0;
            clk <= 0;
        end else begin
            // Increment the clock counter
            counter <= counter + 1;

            // Toggle the clock output at the half period
            if (counter == HALF_PERIOD) begin
                clk <= ~clk;
            end
        end
    end

endmodule