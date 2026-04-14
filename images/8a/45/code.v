module top_module(
    input wire clk_in,
    input wire rst,
    input wire [31:0] freq_div,
    output reg clk_out  // Change from wire to reg
);reg [31:0] counter;
    reg locked;
    reg [31:0] multiplier;
    reg [31:0] divisor;

    always @(posedge clk_in or posedge rst) begin
        if (rst) begin
            counter <= 0;
            locked <= 0;
            clk_out <= 0; // Initialize clk_out
            multiplier <= 0;
            divisor <= 0;
        end else begin
            if (locked) begin
                counter <= counter + 1;
                if (counter == freq_div) begin
                    counter <= 0;
                    clk_out <= ~clk_out; // Toggle clk_out
                end
            end else begin
                counter <= 0;
                multiplier <= 0;
                divisor <= 0;
            end
        end
    end

    always @(posedge clk_in or posedge rst) begin
        if (rst) begin
            locked <= 0;
            multiplier <= 0;
            divisor <= 0;
        end else begin
            if (locked) begin
                multiplier <= multiplier + clk_out; // Accumulate multiplier
                divisor <= divisor + 1; // Change clk_in to 1 for counting cycles
            end else begin
                multiplier <= 0;
                divisor <= 0;
            end
        end
    end

    always @(posedge clk_in or posedge rst) begin
        if (rst) begin
            locked <= 0;
        end else begin
            if (!locked && divisor != 0) begin
                if (multiplier >= divisor) begin
                    clk_out <= 1;
                    locked <= 1;
                end else begin
                    clk_out <= 0;
                end
            end
        end
    end

endmodule