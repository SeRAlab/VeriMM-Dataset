module pll_4x (
    input wire clk_in,
    input wire reset,
    output reg clk_out,
    output reg lock
);
    reg [1:0] counter;
    initial begin
        clk_out = 0;
        lock = 0;
        counter = 0;
    end

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            clk_out <= 0;
            lock <= 0;
            counter <= 0;
        end else begin
            counter <= counter + 1;
            if (counter == 3) begin
                clk_out <= ~clk_out;
                counter <= 0;
                lock <= 1; // Assuming lock is achieved when output toggles
            end
        end
    end
endmodule