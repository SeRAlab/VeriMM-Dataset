module top_module(
    input clk_in,
    input reset,
    output reg clk_out,
    output reg locked
);reg [31:0] counter;
reg [31:0] divisor;

always @(posedge clk_in or posedge reset) begin
    if (reset) begin
        counter <= 0;
        divisor <= 0; // Keep divisor reset to 0
        clk_out <= 0;
        locked <= 0;
    end else begin
        counter <= counter + 1;
        if (counter == divisor) begin
            clk_out <= ~clk_out;
            counter <= 0;
        end
    end
end

always @(posedge clk_in or posedge reset) begin
    if (reset) begin
        locked <= 0;
    end else begin
        if (divisor == 0) begin
            locked <= 0;
        end else if (counter == (divisor - 1)) begin
            locked <= 1;
        end
    end
end

always @(*) begin
    if (clk_in == 0) begin
        divisor = 0; // Make divisor combinational
    end else begin
        divisor = (100_000_000); // Assign a fixed divisor value
    end
end

endmodule