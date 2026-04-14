module top_module(
    input clk_in,
    output reg clk_out
);// Clock period in ps
    localparam PER = 20;

    // Number of cycles for a 50 MHz clock
    localparam COUNT_50MHZ = 100;

    // Number of cycles for a 100 MHz clock
    localparam COUNT_100MHZ = 50;

    // Counter to keep track of the number of cycles
    reg [7:0] counter = 0;

    // Flip-flop to toggle the clock signal
    always @(posedge clk_in) begin
        counter <= counter + 1;
        if (counter == COUNT_100MHZ) begin
            counter <= 0;
            clk_out <= ~clk_out;
        end
    end

    // Frequency checker
    reg [31:0] count = 0;
    reg [31:0] expected_count = 0;
    reg locked = 0;

    always @(posedge clk_out) begin
        count <= count + 1;
        if (count == COUNT_50MHZ) begin
            count <= 0;
            if (expected_count == 0) begin
                expected_count <= COUNT_50MHZ;
            end else if (expected_count == COUNT_50MHZ) begin
                expected_count <= COUNT_100MHZ;
            end else if (expected_count == COUNT_100MHZ) begin
                expected_count <= COUNT_50MHZ;
            end

            if (count == expected_count) begin
                locked <= 1;
            end else begin
                locked <= 0;
            end
        end
    end

endmodule