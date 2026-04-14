module fractional_n_pll (
    input wire clk_ref,       // Reference clock input
    input wire [3:0] ctrl_word, // Control word for division ratio
    input wire reset,         // Asynchronous reset
    output reg clk_out        // Synthesized output clock
);

    reg [3:0] div_ratio;      // Division ratio
    reg [3:0] counter;        // Counter for clock generation
    reg clk_div;              // Divided clock

    always @(posedge clk_ref or posedge reset) begin
        if (reset) begin
            counter <= 0;
            clk_div <= 0;
        end else begin
            if (counter < div_ratio) begin
                counter <= counter + 1;
            end else begin
                counter <= 0;
                clk_div <= ~clk_div; // Toggle the divided clock
            end
        end
    end

    always @(posedge clk_div or posedge reset) begin
        if (reset) begin
            clk_out <= 0;
        end else begin
            clk_out <= ~clk_out; // Output clock toggles with the divided clock
        end
    end

    always @(posedge clk_ref or posedge reset) begin
        if (reset) begin
            div_ratio <= 4'b0001; // Default division ratio
        end else begin
            div_ratio <= ctrl_word; // Update division ratio based on control word
        end
    end
endmodule